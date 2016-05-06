package graphx;

class FloatGraph extends Graph<Float> {
  public function new() {
    var nodeFunctions : NodeFunctions<Float> = {
      isEqual: function(a, b) return a == b,
      getKey: function(a) return Std.string(a)
    };
    super(nodeFunctions);
  }
}
