#!/usr/bin/env python3
"""List recent agent commits that ask for a verdict and have none yet.

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

def api(path):
    req = urllib.request.Request(f"https://api.github.com/repos/{REPO}/{path}",
                                 headers={"Authorization": f"Bearer {os.environ['GH_TOKEN']}",
                                          "Accept": "application/vnd.github+json"})
    return json.load(urllib.request.urlopen(req, timeout=30))

def main():
    targets = {p.stem for p in (pathlib.Path(__file__).resolve().parent.parent / "challenge").glob("*.lean")}
    commits = [c for c in api("commits?per_page=30") if parse_target(c["commit"]["message"]) in targets]
    statuses = {c["sha"]: [s["context"] for s in api(f"commits/{c['sha']}/status")["statuses"]] for c in commits}
    print(json.dumps({"include": select(commits, statuses, targets)}))

if __name__ == "__main__":
    main()
