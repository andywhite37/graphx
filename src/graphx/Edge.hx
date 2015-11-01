package graphx;

class Edge<T> {
  public var from(default, null) : Node<T>;
  public var to(default, null) : Node<T>;

  public function new(from : NodeOrValue<T>, to : NodeOrValue<T>) {
    this.from = from.toNode();
    this.to = to.toNode();
  }
}
