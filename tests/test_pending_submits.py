import pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent / "scripts"))
import pending_submits as ps

def c(sha, msg): return {"sha": sha, "commit": {"message": msg}}

def test_parse_target():
    assert ps.parse_target("submit(erdos105): E105-3 attempt 2\n\nbody") == "erdos105"
    assert ps.parse_target("wip(E105-3): stop") is None
    assert ps.parse_target("fix: mention submit(erdos105): later") is None
    assert ps.parse_target("submit(../x): bad") is None
    assert ps.parse_target("submit(Erdos105): uppercase is not a target id") is None

def test_select_skips_checked_unknown_and_non_submit():
    commits = [c("a1", "submit(erdos105): try"), c("b2", "submit(erdos105): again"),
               c("c3", "wip(T1): stop"), c("d4", "submit(nope): unknown target"),
               c("e5", "submit(trivial): other context only")]
    statuses = {"a1": ["comparator/erdos105"], "b2": [], "e5": ["comparator/erdos105"]}
    got = ps.select(commits, statuses, {"erdos105", "trivial"})
    assert got == [{"sha": "b2", "target": "erdos105"}, {"sha": "e5", "target": "trivial"}]

def test_select_branches_dedupes_shared_commits():
    by_branch = {"main": [c("m1", "submit(green72): b")],
                 "run/a1": [c("a1", "submit(green72): a"), c("m1", "submit(green72): b")]}
    got = ps.select_branches(by_branch, {}, {"green72"})
    assert got == [{"sha": "m1", "target": "green72"}, {"sha": "a1", "target": "green72"}]

def test_watched_branches():
    # Cloud sessions push to their own claude/<name> branch.
    assert ps.watched(["main", "run/b1", "run/a2", "freeze-test", "feature", "claude/focused-faraday-2qp5e1"]) == \
        ["main", "run/b1", "run/a2", "claude/focused-faraday-2qp5e1"]

def test_stale_pending_finds_pending_whose_run_finished():
    statuses = {
        "s1": [{"context": "comparator/green72", "state": "pending", "target_url": "https://github.com/o/r/actions/runs/11"}],
        "s2": [{"context": "comparator/green72", "state": "pending", "target_url": "https://github.com/o/r/actions/runs/12"}],
        "s3": [{"context": "comparator/green72", "state": "success", "target_url": "https://github.com/o/r/actions/runs/13"}],
    }
    finished = {"11": True, "12": False, "13": True}
    assert ps.stale_pending(statuses, finished.get) == [
        ("s1", "comparator/green72", "https://github.com/o/r/actions/runs/11")]

def test_should_stop_idle_restart_or_continue():
    H = 3600
    # Nothing pushed for over 2 hours: stop, no restart.
    assert ps.should_stop(now=10 * H, started=9 * H, last_activity=7.5 * H, max_s=5.5 * H, idle_s=2 * H) == "idle"
    # Recent pushes but the job is near its time limit: hand over to a fresh run.
    assert ps.should_stop(now=5.6 * H, started=0, last_activity=5.5 * H, max_s=5.5 * H, idle_s=2 * H) == "restart"
    # Recent pushes, plenty of time left: keep polling.
    assert ps.should_stop(now=1 * H, started=0, last_activity=0.9 * H, max_s=5.5 * H, idle_s=2 * H) is None

def test_latest_activity_reads_commit_dates():
    by_branch = {"main": [{"sha": "a", "commit": {"message": "x", "committer": {"date": "2026-10-03T19:00:00Z"}}}],
                 "run/b1": [{"sha": "b", "commit": {"message": "y", "committer": {"date": "2026-10-03T19:30:00Z"}}}]}
    import datetime
    assert ps.latest_activity(by_branch) == datetime.datetime(2026, 10, 3, 19, 30, tzinfo=datetime.timezone.utc).timestamp()

def test_api_accepts_empty_response(monkeypatch):
    # A workflow dispatch answers 204 with no body; on 2026-10-03 that crashed the poller loop.
    import io
    monkeypatch.setenv("GH_TOKEN", "x")
    monkeypatch.setattr(ps.urllib.request, "urlopen", lambda req, timeout: io.BytesIO(b""))
    assert ps.api("actions/workflows/verify.yml/dispatches", body={"ref": "main"}) is None
