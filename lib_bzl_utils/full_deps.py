from typing import List, Optional, Dict
import json

from bfs.bfs_ import bfs

_DEPS = {
    "pathos": ["ppft"],
}


DepGraph = Dict[str, List[str]]


def format_deps(deps: Optional[DepGraph] = None) -> DepGraph:
    deps_ = deps if deps is not None else _DEPS
    res: DepGraph = {}
    for pkg in deps_:
        res[pkg] = bfs(deps_, pkg)[1:]
    return res


def _test_format_deps() -> None:
    deps = {
        "A": ["B"],
        "X": ["A"],
        "Y": ["X", "Z"],
    }
    assert format_deps(deps) == {'A': ['B'], 'X': ['A', 'B'], 'Y': ['X', 'Z', 'A', 'B']}


if __name__ == '__main__':
    print(json.dumps(format_deps(), sort_keys=True, indent=4))
    _test_format_deps()
