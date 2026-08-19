import Text "mo:core/Text";
import Array "mo:core/Array";

module {
  public func joinRow(fields : [Text]) : Text {
    Text.join(",", fields.vals());
  };
  public func splitRow(row : Text) : [Text] {
    Array.map<Text, Text>([row], func(r) { r });
  };
};
