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
