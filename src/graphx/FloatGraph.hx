package graphx;

class FloatGraph extends Graph<Float> {
  public function new() {
    super({
      equals: function(a, b) return a == b,
      getKey: function(a) return Std.string(a)
    });
  }
}
