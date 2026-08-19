import Time "mo:core/Time";

module {
  public func now() : Int {
    Time.now();
  };

  public func seconds(value : Int) : Int {
    value * 1_000_000_000;
  };

  public func minutes(value : Int) : Int {
    seconds(value * 60);
  };
};
