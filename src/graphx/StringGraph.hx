package graphx;

class StringGraph extends Graph<String> {
  public function new() {
    var nodeFunctions : NodeFunctions<String> = {
      isEqual: function(a : String, b : String) return a == b,
      getKey: function(a : String) return a
    };
    super(nodeFunctions);
  }
}
