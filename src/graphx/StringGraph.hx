package graphx;

class StringGraph extends Graph<String> {
  public function new() {
    super({
      equals: function(a, b) return a == b,
      getKey: function(a) return a
    });
  }
}
