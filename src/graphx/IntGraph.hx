package graphx;

class IntGraph extends Graph<Int> {
  public function new() {
    super({
      equals: function(a, b) return a == b,
      getKey: function(a) return Std.string(a)
    });
  }
}
