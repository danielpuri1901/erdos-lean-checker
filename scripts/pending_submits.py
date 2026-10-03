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
import datetime, json, os, pathlib, re, sys, time, urllib.request

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

def should_stop(now, started, last_activity, max_s, idle_s):
    """'idle' when nothing was pushed for idle_s, 'restart' when the job nears max_s, else None."""
    if now - last_activity > idle_s:
        return "idle"
    if now - started > max_s:
        return "restart"
    return None

def latest_activity(by_branch):
    """Newest commit time (epoch seconds) across the watched branches."""
    dates = [c["commit"]["committer"]["date"] for commits in by_branch.values() for c in commits]
    return max(datetime.datetime.fromisoformat(d.replace("Z", "+00:00")).timestamp() for d in dates) if dates else 0.0

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

def scan():
    """One pass: fail stale pending checks, return (submits needing a verdict, newest commit time)."""
    targets = {p.stem for p in (pathlib.Path(__file__).resolve().parent.parent / "challenge").glob("*.lean")}
    branches = watched([b["name"] for b in api("branches?per_page=100")])
    all_commits = {b: api(f"commits?sha={b}&per_page=30") for b in branches}
    by_branch = {b: [c for c in commits if parse_target(c["commit"]["message"]) in targets] for b, commits in all_commits.items()}
    shas = {c["sha"] for commits in by_branch.values() for c in commits}
    full = {sha: api(f"commits/{sha}/status")["statuses"] for sha in shas}
    for sha, context, url in stale_pending(full, run_finished):
        api(f"statuses/{sha}", body={"state": "failure", "context": context, "target_url": url, "description": STALE})
    statuses = {sha: [s["context"] for s in items] for sha, items in full.items()}
    return select_branches(by_branch, statuses, targets), latest_activity(all_commits)

def dispatch(workflow, inputs=None):
    api(f"actions/workflows/{workflow}/dispatches", repo=CHECKER, token_env="CHECKER_TOKEN",
        body={"ref": "main", "inputs": inputs or {}})

def loop(every_s=120, max_s=5.5 * 3600, idle_s=2 * 3600):
    """Poll until nothing was pushed for idle_s; near max_s, start a fresh run of this workflow and exit.
    GitHub's own schedule fired only twice in 7.5 hours on 2026-10-03, so the poller keeps itself alive."""
    started, dispatched = time.time(), set()
    while True:
        try:
            pending, activity = scan()
        except Exception as e:  # one failed API call must not end the poller
            print(f"scan failed: {e}", flush=True); time.sleep(every_s); continue
        for item in pending:
            if item["sha"] not in dispatched:
                dispatch("verify.yml", {"agent_commit": item["sha"], "target": item["target"]})
                dispatched.add(item["sha"]); print(f"verify {item['sha'][:7]} {item['target']}", flush=True)
        stop = should_stop(time.time(), started, activity, max_s, idle_s)
        if stop == "idle":
            print("no pushes for 2 hours; poller stops", flush=True); return
        if stop == "restart":
            dispatch("check-submits.yml"); print("handing over to a fresh poller run", flush=True); return
        time.sleep(every_s)

if __name__ == "__main__":
    if sys.argv[1:] == ["--loop"]:
        loop()
    else:
        pending, _ = scan()
        print(json.dumps({"include": pending}))
