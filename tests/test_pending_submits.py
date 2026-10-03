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
