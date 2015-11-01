package graphx;

class Node<T> {
  public var value(default, null) : T;

  public function new(value : T) {
    this.value = value;
  }
}
