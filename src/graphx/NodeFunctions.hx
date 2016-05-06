package graphx;

typedef NodeFunctions<T> = {
  isEqual: T -> T -> Bool,
  getKey: T -> String
};
