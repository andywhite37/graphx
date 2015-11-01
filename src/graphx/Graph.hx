package graphx;

using Lambda;

class Graph<T> {
  var nodes(default, null) : Array<Node<T>>;
  var edges(default, null) : Array<Edge<T>>;
  var nodeFunctions(default, null) : NodeFunctions<T>;

  public function new(nodeFunctions : NodeFunctions<T>) {
    this.nodes = [];
    this.edges = [];
    this.nodeFunctions = nodeFunctions;
  }

  public function addNode(nv : NodeOrValue<T>) : Graph<T> {
    if (!contains(nv)) {
      nodes.push(nv.toNode());
    }
    return this;
  }

  public function addEdgeFrom(from : NodeOrValue<T>, to : NodeOrValue<T>) : Graph<T> {
    addNode(from);
    addNode(to);
    var edge = new Edge(from, to);
    edges.push(edge);
    return this;
  }

  public function addEdgeTo(to : NodeOrValue<T>, from : NodeOrValue<T>) : Graph<T> {
    return addEdgeFrom(from, to);
  }

  public function addEdgesFrom(from : NodeOrValue<T>, tos : Array<NodeOrValue<T>>) : Graph<T> {
    return tos.fold(function(to, acc : Graph<T>) {
      return acc.addEdgeFrom(from, to);
    }, this);
  }

  public function addEdgesTo(to : NodeOrValue<T>, froms : Array<NodeOrValue<T>>) : Graph<T> {
    return froms.fold(function(from, acc : Graph<T>) {
      return acc.addEdgeFrom(from, to);
    }, this);
  }

  public function getEdgesOut(nv : NodeOrValue<T>) : Array<Edge<T>> {
    return edges.filter(function(edge) {
      return nodeFunctions.equals(nv.toValue(), edge.from.value);
    });
  }

  public function getEdgesIn(nv : NodeOrValue<T>) : Array<Edge<T>> {
    return edges.filter(function(edge) {
      return nodeFunctions.equals(nv.toValue(), edge.to.value);
    });
  }

  public function dfs<TAcc>(callback: TAcc -> Node<T> -> TAcc, acc : TAcc) : TAcc {
    var visited : Map<String, Bool> = new Map();
    function dfsFromNode(node : Node<T>) {
      var key = nodeFunctions.getKey(node.value);
      if (visited.exists(key)) {
        return acc;
      }
      visited.set(key, true);
      var unvisitedEdgesOut = getEdgesOut(node).filter(function(edge) {
        return !visited.exists(nodeFunctions.getKey(edge.to.value));
      });
      if (unvisitedEdgesOut.length > 0) {
        acc = unvisitedEdgesOut.fold(function(unvisitedEdge, acc) {
          return dfsFromNode(unvisitedEdge.to);
        }, acc);
      }
      return callback(acc, node);
    }
    return nodes.fold(function(node, acc : TAcc) {
      return dfsFromNode(node);
    }, acc);
  }

  public function bfs<TAcc>() : TAcc {
    throw 'not implemented';
  }

  public function hasCycle() : Bool {
    throw 'not implemented';
  }

  public function topologicalSort() : Array<T> {
    var result = dfs(function(acc : Array<T>, node) {
      acc.push(node.value);
      return acc;
    }, []);
    result.reverse();
    return result;
  }

  public function clone() : Graph<T> {
    var newGraph = new Graph(nodeFunctions);
    newGraph = nodes.fold(function(node, acc) {
      return newGraph = newGraph.addNode(new Node(node.value));
    }, newGraph);
    newGraph = edges.fold(function(edge, acc) {
      return newGraph = newGraph.addEdgeFrom(edge.from.value, edge.to.value);
    }, newGraph);
    return newGraph;
  }

  public function contains(nv : NodeOrValue<T>) : Bool {
    return anyNode(function(node) {
      return nodeFunctions.equals(node.value, nv.toValue());
    });
  }

  public function anyNode(predicate : Node<T> -> Bool) {
    for (node in nodes)
      if (predicate(node)) return true;
    return false;
  }

  public function allNodes(predicate : Node<T> -> Bool) {
    for (node in nodes)
      if (!predicate(node)) return false;
    return true;
  }
}
