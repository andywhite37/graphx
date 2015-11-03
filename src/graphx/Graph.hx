package graphx;

import haxe.Json;
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
    if (!contains(nv)) nodes.push(nv.toNode());
    return this;
  }

  public function addEdgeFrom(from : NodeOrValue<T>, to : NodeOrValue<T>) : Graph<T> {
    addNode(from);
    addNode(to);
    edges.push(new Edge(from, to));
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
      return equals(nv, edge.from);
    });
  }

  public function getEdgesIn(nv : NodeOrValue<T>) : Array<Edge<T>> {
    return edges.filter(function(edge) {
      return equals(nv, edge.to);
    });
  }

  public function dfs<TAcc>(visit: TAcc -> Node<T> -> TAcc, acc : TAcc) : TAcc {
    var visited : Map<String, Bool> = new Map();

    function dfsFromNode(node : Node<T>) : TAcc {
      // Check if we've already visited this node
      var key = getKey(node);
      if (visited.exists(key)) return acc;
      visited.set(key, true);

      // Get unvisited nodes from the current node
      var unvisitedNodes = getEdgesOut(node)
        .filter(function(edge) {
          return !visited.exists(getKey(edge.to));
        })
        .map(function(edge) {
          return edge.to;
        });

      // Traverse referenced nodes
      acc = unvisitedNodes.fold(function(unvisitedNode, acc) {
        return dfsFromNode(unvisitedNode);
      }, acc);

      // Visit the current node
      return visit(acc, node);
    }
    return nodes.fold(function(node, acc : TAcc) {
      return dfsFromNode(node);
    }, acc);
  }

  public function bfs<TAcc>(visit : TAcc -> Node<T> -> TAcc, acc : TAcc) : TAcc {
    var queue : Array<Node<T>> = [];
    var visited : Map<String, Bool> = new Map();

    function bfsForNode(node : Node<T>) : TAcc {
      queue.push(node);

      while (queue.length > 0) {
        var currentNode = queue.shift();

        var key = getKey(currentNode);
        if (visited.exists(key)) continue;
        visited.set(key, true);

        acc = visit(acc, currentNode);

        var unvisitedNodes = getEdgesOut(currentNode)
          .filter(function(edge) {
            return !visited.exists(getKey(edge.to));
          })
          .map(function(edge) {
            return edge.to;
          });

        unvisitedNodes.iter(function(unvisitedNode) {
          queue.push(unvisitedNode);
        });
      }

      return acc;
    }

    // Visit the nodes in the queue, which contains the breadth-first sequence of nodes
    return nodes.fold(function(node, acc : TAcc) {
      return bfsForNode(node);
    }, acc);
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
      return newGraph.addNode(new Node(node.value));
    }, newGraph);
    newGraph = edges.fold(function(edge, acc) {
      return newGraph.addEdgeFrom(edge.from.value, edge.to.value);
    }, newGraph);
    return newGraph;
  }

  public function contains(nv : NodeOrValue<T>) : Bool {
    return anyNode(function(node) {
      return equals(node, nv);
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

  public function getKey(node : Node<T>) : String {
    return nodeFunctions.getKey(node.value);
  }

  public function equals(a : Node<T>, b : Node<T>) : Bool {
    return nodeFunctions.equals(a.value, b.value);
  }

  public function toObject() : { nodes: Array<T>, edges : Array<{ from : T, to : T }> } {
    return {
      nodes: nodes.map(function(node) {
        return node.value;
      }),
      edges: edges.map(function(edge) {
        return {
          from: edge.from.value,
          to: edge.to.value
        };
      })
    };
  }

  public function toString() : String {
    return Json.stringify(toObject(), null, '  ');
  }
}
