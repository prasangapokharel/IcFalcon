module {
  public type Hooks = { pre : ?() -> (); post : ?() -> () };
  public func runPre(h : Hooks) : () { switch (h.pre) { case (?f) f(); case (null) () } };
  public func runPost(h : Hooks) : () { switch (h.post) { case (?f) f(); case (null) () } };
};
