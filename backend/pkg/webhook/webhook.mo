import Text "mo:core/Text";
import Time "mo:core/Time";

module {
  public type Event = { name : Text; payload : Text; createdAt : Int };
  public func create(name : Text, payload : Text) : Event {
    { name; payload; createdAt = Time.now() };
  };
};
