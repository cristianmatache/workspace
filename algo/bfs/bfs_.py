from typing import List, Dict, TypeVar, Hashable

T = TypeVar('T', bound=Hashable)


def bfs(graph: Dict[T, List[T]], node: T) -> List[T]:
    visited, queue = [node], [node]
    while queue:
        current_node = queue.pop(0)
        if current_node not in graph:
            continue
        for neighbour in graph[current_node]:
            if neighbour not in visited:
                visited.append(neighbour)
                queue.append(neighbour)
    return visited


def test_bfs() -> None:
    graph: Dict[str, List[str]] = {
        'A': ['B', 'C'],
        'B': ['D', 'E'],
        'C': ['F'],
        'D': [],
        'E': ['F'],
        'F': []
    }
    assert bfs(graph, 'A') == ['A', 'B', 'C', 'D', 'E', 'F']


if __name__ == '__main__':
    test_bfs()
