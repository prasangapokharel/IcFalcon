# Equality and Comparison

Choosing between `==`, `equal`, and `compare`.

## `==` vs `equal`

Default to `equal` / `compare`. Use `==` only for primitives with no receiver
form — `Nat`, `Int`, `Float`, sized ints.

`==` is structural equality for **shared** types only. A `var` field removes
shared-ness:

```motoko
type Todo = { id : Nat; var completed : Bool };
a == b
// M0060 — operator not defined for operand types
```

`equal`/`compare` are what `Map`, `Set`, `contains` take as implicit arguments.

```motoko
let map = Map.empty<Nat, Text>();
numbers.contains(3);
friends.contains(p);
friends.contains(Principal.equal, p);
// M0237 — redundant explicit implicit
```

## Receiver `.equal` / `.compare`

| Type | `a.equal(b)` | `a.compare(b)` |
|---|---|---|
| `Text`, `Principal`, `Bool`, `Char`, `Blob` | yes | yes |
| `Order` | yes | no — `Order.equal` only |
| `Nat`, `Int`, `Float`, sized ints | no | no |

```motoko
myNat.equal(other)
// M0070 — Nat has no receiver equal

Nat.equal(myNat, other)
myNat == other
```

## Custom records and variants

`Map`/`Set` keys need explicit `compare`:

```motoko
module Point {
  public func compare(a : Point, b : Point) : Order.Order {
    switch (Nat.compare(a.x, b.x)) {
      case (#equal) { Nat.compare(a.y, b.y) };
      case other { other };
    };
  };
};
```

Custom variants need both `equal` and `compare` written out. `Result` from
`mo:core` ships them.

For one-off checks on immutable records, `==` is fine. Do not build on `==` for
types whose fields may become `var`.
