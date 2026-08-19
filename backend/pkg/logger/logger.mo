import Time "mo:core/Time";
import Text "mo:core/Text";
import Int "mo:core/Int";

module {
  public type Level = { #debug; #info; #warn; #error };
  public func log(level : Level, message : Text) : Text {
    levelTag(level) # " " # Int.toText(Time.now()) # " " # message;
  };
  func levelTag(l : Level) : Text {
    switch (l) { case (#debug) "DEBUG"; case (#info) "INFO"; case (#warn) "WARN"; case (#error) "ERROR" };
  };
};
