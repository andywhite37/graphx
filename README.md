# graphx

Basic object graph utilities for Haxe

## Features

- Graph creation for nodes of the same type
- Depth-first search
- Breadth-first search (TODO)
- Cycle detection (TODO)
- Topological sort

## Examples

```Haxe
var graph : Graph<String> = new Graph({
  equals: function(a, b) return a == b,
  getKey: function(a) return a
});
graph.addEdgesFrom("eat breakfast", ["take out trash"]);
graph.addEdgesFrom("brush teeth", ["shave"]);
graph.addEdgesFrom("get dressed", ["eat breakfast", "read paper"]);
graph.addEdgesFrom("shave", ["get dressed"]);
graph.addEdgesFrom("wake up", ["brush teeth", "take shower"]);
graph.addEdgesFrom("take out trash", ["go to work"]);

var results = graph.topologicalSort();
trace(results);
// ["wake up", "take shower", "brush teeth", "shave", "get dressed",
//  "read paper", "eat breakfast", "take out trash", "go to work"]
```

## API

TODO
