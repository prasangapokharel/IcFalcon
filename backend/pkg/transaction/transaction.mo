import Iter "mo:core/Iter";
import Ledger "mo:pkg/ledger/ledger";
import Map "mo:core/Map";
import Nat "mo:core/Nat";
import Principal "mo:core/Principal";
import Text "mo:core/Text";

module {
  public type TxKind = {
    #deposit;
    #withdraw;
    #transferOut;
    #transferIn;
    #fee;
  };

  public type TxStatus = { #pending; #completed; #failed };

  public type TxRecord = {
    id : Text;
    user : Principal;
    kind : TxKind;
    amount : Nat;
    fee : Nat;
    counterparty : ?Principal;
    token : Ledger.TokenRef;
    blockIndex : ?Nat;
    status : TxStatus;
    createdAt : Int;
    memo : ?Text;
  };

  public type TxStore = Map.Map<Text, TxRecord>;

  public func kindForSender() : TxKind { #transferOut };
  public func kindForRecipient() : TxKind { #transferIn };

  public func emptyStore() : TxStore { Map.empty() };

  public func insert(store : TxStore, tx : TxRecord) : () {
    Map.add(store, Text.compare, tx.id, tx);
  };

  public func getByTransferId(store : TxStore, id : Text) : ?TxRecord {
    Map.get(store, Text.compare, id);
  };

  public func listByUser(store : TxStore, user : Principal) : [TxRecord] {
    Iter.toArray(
      Iter.filter(
        Map.values(store),
        func(tx : TxRecord) : Bool { tx.user == user },
      ),
    );
  };
};
