import Nat "mo:core/Nat";
import Text "mo:core/Text";

module {
  public type Part = { index : Nat; data : [Nat8] };
  public type Upload = { id : Text; parts : [Part]; var complete : Bool };
  public func addPart(u : Upload, part : Part) : Upload {
    { u with parts = Array.append(u.parts, [part]) };
  };
  public func markComplete(u : Upload) : Upload { { u with complete = true } };
};

import Array "mo:core/Array";
