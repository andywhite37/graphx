package graphx;

import utest.Assert;

class TestGraph {
  public function new() {}

  public function createGraph1() {
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
    return graph;
  }

  public function createGraph2() {
    var graph : Graph<Int> = new Graph({
      equals: function(a, b) return a == b,
      getKey: function(a) return Std.string(a)
    });
    // https://en.wikipedia.org/wiki/Topological_sorting#/media/File:Directed_acyclic_graph.png
    graph.addEdgesFrom(7, [11, 8]);
    graph.addEdgesFrom(5, [11]);
    graph.addEdgesFrom(3, [8, 10]);
    graph.addEdgesFrom(11, [2, 9, 10]);
    graph.addEdgesFrom(8, [9]);
    return graph;
  }

  public function testDfs1() {
    var graph = createGraph1();
    var results = graph.dfs(function(acc, node) {
      acc.push(node.value);
      return acc;
    }, []);
    Assert.pass();
  }

  public function testDfs2() {
    var graph = createGraph2();
    var results = graph.dfs(function(acc, node) {
      acc.push(node.value);
      return acc;
    }, []);
    Assert.pass();
  }

  public function testTopologicalSort1() {
    var graph = createGraph1();
    var results = graph.topologicalSort();
    Assert.same([
      "wake up",
      "take shower",
      "brush teeth",
      "shave",
      "get dressed",
      "read paper",
      "eat breakfast",
      "take out trash",
      "go to work"
    ], results);
  }

  public function testTopologicalSort2() {
    var graph = createGraph2();
    var result = graph.topologicalSort();
    Assert.same([3, 5, 7, 8, 11, 10, 9, 2], result);
  }
}
