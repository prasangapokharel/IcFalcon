import Text "mo:core/Text";
import Array "mo:core/Array";

module {
  public func contains(haystack : Text, needle : Text) : Bool {
    Text.contains(haystack, #text needle);
  };
  public func filterContains<T>(items : [T], needle : Text, project : T -> Text) : [T] {
    Array.filter(items, func(i : T) : Bool { contains(project(i), needle) });
  };
};
