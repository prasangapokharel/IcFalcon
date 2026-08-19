module {
  public func isBalanced(json : Text) : Bool {
    var depth = 0;
    for (c in json.chars()) {
      if (c == '{') depth += 1;
      if (c == '}') { if (depth == 0) return false; depth -= 1 };
    };
    depth == 0;
  };
};
