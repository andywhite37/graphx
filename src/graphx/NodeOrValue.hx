package graphx;

enum NodeOrValueType<T> {
  NVNode(node : Node<T>);
  NVValue(value : T);
}

abstract NodeOrValue<T>(NodeOrValueType<T>) {
  public function new(nodeOrValueType : NodeOrValueType<T>) {
    this = nodeOrValueType;
  }

  @:from
  public static function fromNode<T>(node : Node<T>) : NodeOrValue<T> {
    return new NodeOrValue(NVNode(node));
  }

  @:from
  public static function fromValue<T>(value : T) : NodeOrValue<T> {
    return new NodeOrValue(NVValue(value));
  }

  @:to
  public function toNode() : Node<T> {
    return switch this {
      case NVNode(node) : node;
      case NVValue(value) : new Node(value);
    };
  }

  @:to
  public function toValue() : T {
    return switch this {
      case NVNode(node) : node.value;
      case NVValue(value) : value;
    };
  }
}
