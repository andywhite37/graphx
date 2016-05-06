package graphx;

class IntGraph extends Graph<Int> {
  public function new() {
    var nodeFunctions : NodeFunctions<Int> = {
      isEqual: function(a : Int, b : Int) : Bool {
        return a == b;
      },
      getKey: function(a : Int) : String {
        return Std.string(a);
      }
    };
    super(nodeFunctions);
  }
}
