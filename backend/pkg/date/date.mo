import Time "mo:core/Time";
import Int "mo:core/Int";

module {
  public let day : Int = 86_400_000_000_000;
  public func now() : Int { Time.now() };
  public func daysAgo(n : Int) : Int { Time.now() - n * day };
  public func isExpired(at : Int) : Bool { Time.now() > at };
  public func addDays(at : Int, n : Int) : Int { at + n * day };
};
