package graphx;

typedef NodeFunctions<T> = {
  equals: T -> T -> Bool,
  getKey: T -> String
};
