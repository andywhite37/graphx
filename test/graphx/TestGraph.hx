package graphx;

import utest.Assert;

class TestGraph {
  public function new() {}

  ////////////////////////////////////////////////////////////////////////////////
  // Graphs for testing
  ////////////////////////////////////////////////////////////////////////////////

  public function createEmptyGraph() : Graph<Int> {
    return new IntGraph();
  }

  public function createSingletonGraph() : Graph<Int> {
    return new IntGraph()
      .addNode(42);
  }

  public function createBinaryTreeGraph() {
    return new IntGraph()
      .addEdgesFrom(1, [2, 3])
      .addEdgesFrom(2, [4, 5])
      .addEdgesFrom(3, [6, 7])
      .addEdgesFrom(4, [8, 9]);
  }

  public function createScheduleGraph() : Graph<String> {
    return new StringGraph()
      .addEdgesFrom("eat breakfast", ["take out trash"])
      .addEdgesFrom("brush teeth", ["shave"])
      .addEdgesFrom("get dressed", ["eat breakfast", "read paper"])
      .addEdgesFrom("shave", ["get dressed"])
      .addEdgesFrom("wake up", ["brush teeth", "take shower"])
      .addEdgesFrom("take out trash", ["go to work"]);
  }

  public function createIntGraph() : Graph<Int> {
    return new IntGraph()
      // https://en.wikipedia.org/wiki/Topological_sorting#/media/File:Directed_acyclic_graph.png
      .addEdgesFrom(7, [11, 8])
      .addEdgesFrom(5, [11])
      .addEdgesFrom(3, [8, 10])
      .addEdgesFrom(11, [2, 9, 10])
      .addEdgesFrom(8, [9]);
  }

  public function createSingletonGraphWithCycle() : Graph<Int> {
    return new IntGraph()
      .addEdgeFrom(1, 1);
  }

  public function createGraphWithCycle() : Graph<Int> {
    return new IntGraph()
      .addEdgeFrom(1, 2)
      .addEdgeFrom(2, 3)
      .addEdgeFrom(3, 1);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Depth-first search
  ////////////////////////////////////////////////////////////////////////////////

  public function testDfsEmptyGraph() {
    var graph = createEmptyGraph();
    var results = graph.dfs(function(acc : Array<Int>, node) {
      acc.push(node.value);
      return acc;
    }, []);
    Assert.same([], results);
  }

  public function testDfsSingletonGraph(){
    var graph = createSingletonGraph();
    var results = graph.dfs(function(acc : Array<Int>, node) {
      acc.push(node.value);
      return acc;
    }, []);
    Assert.same([42], results);
  }

  public function testDfsBinaryTreeGraph() {
    var graph = createBinaryTreeGraph();
    var results = graph.dfs(function(acc, node) {
      acc.push(node.value);
      return acc;
    }, []);
    Assert.same([8, 9, 4, 5, 2, 6, 7, 3, 1], results);
  }

  public function testDfsScheduleGraph() {
    var graph = createScheduleGraph();
    var results = graph.dfs(function(acc, node) {
      acc.push(node.value);
      return acc;
    }, []);
    Assert.same([
      "go to work",
      "take out trash",
      "eat breakfast",
      "read paper",
      "get dressed",
      "shave",
      "brush teeth",
      "take shower",
      "wake up",
    ], results);
  }

  public function testDfsIntGraph() {
    var graph = createIntGraph();
    var results = graph.dfs(function(acc, node) {
      acc.push(node.value);
      return acc;
    }, []);
    Assert.same([2, 9, 10, 11, 8, 7, 5, 3], results);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Breadth-first search
  ////////////////////////////////////////////////////////////////////////////////

  public function testBfsEmptyGraph() {
    var graph = createEmptyGraph();
    var results = graph.bfs(function(acc : Array<Int>, node) {
      acc.push(node.value);
      return acc;
    }, []);
    Assert.same([], results);
  }

  public function testBfsSingletonGraph() {
    var graph = createSingletonGraph();
    var results = graph.bfs(function(acc : Array<Int>, node) {
      acc.push(node.value);
      return acc;
    }, []);
    Assert.same([42], results);
  }

  public function testBfsBinaryTreeGraph() {
    var graph = createBinaryTreeGraph();
    var results = graph.bfs(function(acc, node) {
      acc.push(node.value);
      return acc;
    }, []);
    Assert.same([1, 2, 3, 4, 5, 6, 7, 8, 9], results);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Topological sort
  ////////////////////////////////////////////////////////////////////////////////

  public function testTopologicalSortEmptyGraph() {
    var graph = createEmptyGraph();
    var results = graph.topologicalSort();
    Assert.same([], results);
  }

  public function testTopologicalSortSingletonGraph() {
    var graph = createSingletonGraph();
    var results = graph.topologicalSort();
    Assert.same([42], results);
  }

  public function testTopologicalSortScheduleGraph() {
    var graph = createScheduleGraph();
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

  public function testTopologicalSortIntGraph() {
    var graph = createIntGraph();
    var result = graph.topologicalSort();
    Assert.same([3, 5, 7, 8, 11, 10, 9, 2], result);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Has cycle
  ////////////////////////////////////////////////////////////////////////////////

  /*
  public function testHasCycleEmptyGraph() {
    var graph = createEmptyGraph();
    Assert.isFalse(graph.hasCycle());
  }

  public function testHasCycleSingletonGraph() {
    var graph = createSingletonGraph();
    Assert.isFalse(graph.hasCycle());
  }

  public function testHasCycleScheduleGraph() {
    var graph = createScheduleGraph();
    Assert.isFalse(graph.hasCycle());
  }

  public function testHasCycleSingletonGraphWithCycle() {
    var graph = createSingletonGraphWithCycle();
    Assert.isTrue(graph.hasCycle());
  }

  public function testHasCycleGraphWithCycle() {
    var graph = createGraphWithCycle();
    Assert.isTrue(graph.hasCycle());
  }
  */
}
