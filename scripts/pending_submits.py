#!/usr/bin/env python3
"""List recent agent commits that ask for a verdict and have none yet.

It scans `main`, every `run/*` branch (one per measured run), and every `claude/*` branch
(cloud sessions push their work to a branch of that name).

A commit asks for a verdict when its message starts with `submit(<target>):` and
`challenge/<target>.lean` exists here. It has a verdict once any `comparator/<target>`
status exists on it (pending included, so a running check is not started twice).
Prints a GitHub Actions matrix: {"include": [{"sha": ..., "target": ...}, ...]}.
"""
import json, os, pathlib, re, urllib.request

REPO = "danielpuri1901/erdos-lean-formalization"
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

def watched(names):
    return [n for n in names if n == "main" or n.startswith(("run/", "claude/"))]

def select_branches(by_branch, statuses, targets):
    out, seen = [], set()
    for commits in by_branch.values():
        for item in select(commits, statuses, targets):
            if item["sha"] not in seen:
                seen.add(item["sha"]); out.append(item)
    return out

def api(path):
    req = urllib.request.Request(f"https://api.github.com/repos/{REPO}/{path}",
                                 headers={"Authorization": f"Bearer {os.environ['GH_TOKEN']}",
                                          "Accept": "application/vnd.github+json"})
    return json.load(urllib.request.urlopen(req, timeout=30))

def main():
    targets = {p.stem for p in (pathlib.Path(__file__).resolve().parent.parent / "challenge").glob("*.lean")}
    branches = watched([b["name"] for b in api("branches?per_page=100")])
    by_branch = {b: [c for c in api(f"commits?sha={b}&per_page=30") if parse_target(c["commit"]["message"]) in targets]
                 for b in branches}
    shas = {c["sha"] for commits in by_branch.values() for c in commits}
    statuses = {sha: [s["context"] for s in api(f"commits/{sha}/status")["statuses"]] for sha in shas}
    print(json.dumps({"include": select_branches(by_branch, statuses, targets)}))

if __name__ == "__main__":
    main()
