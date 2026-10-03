#!/usr/bin/env python3
"""List recent agent commits that ask for a verdict and have none yet.

It scans `main`, every `run/*` branch (one per measured run), and every `claude/*` branch
(cloud sessions push their work to a branch of that name).

A commit asks for a verdict when its message starts with `submit(<target>):` and
`challenge/<target>.lean` exists here. It has a verdict once any `comparator/<target>`
status exists on it (pending included, so a running check is not started twice).
Prints a GitHub Actions matrix: {"include": [{"sha": ..., "target": ...}, ...]}.

A check whose runner dies (for example out of memory) never writes its final status, so the
commit would stay `pending` forever. Before printing, this script turns every `pending`
comparator status whose checker run has finished into a `failure` with a description that says so.
"""
import json, os, pathlib, re, urllib.request

REPO = "danielpuri1901/erdos-lean-formalization"
CHECKER = "danielpuri1901/erdos-lean-checker"
STALE = "checker run ended without a verdict (runner shut down, often out of memory); fix and submit again"
SUBMIT = re.compile(r"submit\(([a-z0-9_-]+)\):")

def parse_target(message: str):
    m = SUBMIT.match(message)
    return m.group(1) if m else None

def select(commits, statuses, targets):
    out = []
    for c in commits:
        t = parse_target(c["commit"]["message"])
        if t in targets and f"comparator/{t}" not in statuses.get(c["sha"], []):
            out.append({"sha": c["sha"], "target": t})
    return out

def stale_pending(statuses, run_finished):
    """(sha, context, target_url) for each pending comparator status whose checker run has finished."""
    out = []
    for sha, items in statuses.items():
        for st in items:
            if st["context"].startswith("comparator/") and st["state"] == "pending":
                if run_finished(st["target_url"].rstrip("/").rsplit("/", 1)[-1]):
                    out.append((sha, st["context"], st["target_url"]))
    return out

def watched(names):
    return [n for n in names if n == "main" or n.startswith(("run/", "claude/"))]

def select_branches(by_branch, statuses, targets):
    out, seen = [], set()
    for commits in by_branch.values():
        for item in select(commits, statuses, targets):
            if item["sha"] not in seen:
                seen.add(item["sha"]); out.append(item)
    return out

def api(path, repo=REPO, token_env="GH_TOKEN", body=None):
    req = urllib.request.Request(f"https://api.github.com/repos/{repo}/{path}",
                                 data=json.dumps(body).encode() if body else None,
                                 headers={"Authorization": f"Bearer {os.environ[token_env]}",
                                          "Accept": "application/vnd.github+json"})
    return json.load(urllib.request.urlopen(req, timeout=30))

def run_finished(run_id):
    return api(f"actions/runs/{run_id}", repo=CHECKER, token_env="CHECKER_TOKEN")["status"] == "completed"

def main():
    targets = {p.stem for p in (pathlib.Path(__file__).resolve().parent.parent / "challenge").glob("*.lean")}
    branches = watched([b["name"] for b in api("branches?per_page=100")])
    by_branch = {b: [c for c in api(f"commits?sha={b}&per_page=30") if parse_target(c["commit"]["message"]) in targets]
                 for b in branches}
    shas = {c["sha"] for commits in by_branch.values() for c in commits}
    full = {sha: api(f"commits/{sha}/status")["statuses"] for sha in shas}
    for sha, context, url in stale_pending(full, run_finished):
        api(f"statuses/{sha}", body={"state": "failure", "context": context, "target_url": url, "description": STALE})
    statuses = {sha: [s["context"] for s in items] for sha, items in full.items()}
    print(json.dumps({"include": select_branches(by_branch, statuses, targets)}))

if __name__ == "__main__":
    main()
