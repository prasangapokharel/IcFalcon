# Type Conversions

Numerical type conversions between `Nat`, `Int`, and sized variants.

## Nat to Int

```motoko
let natValue = 42;
let intValue = natValue.toInt();
let backToNat = Int.abs(intValue);
```

## Nat size chain

```motoko
let nat8 : Nat8 = 255;
let nat16 = nat8.toNat16();
let nat32 = nat16.toNat32();
let nat64 = nat32.toNat64();
let backToNat8 = Nat8.fromNat64(nat64);
```

Widen: `Nat8 → Nat16 → Nat32 → Nat64`. Narrow with `fromNatXX`.

## Int size chain

```motoko
let int8 : Int8 = -128;
let int16 = int8.toInt16();
let int32 = int16.toInt32();
let int64 = int32.toInt64();
let backToInt8 = Int8.fromInt64(int64);
```

## Common patterns

```motoko
let text = myNat.toText();
let maybeNat = Nat.fromText("42");
let maybeInt = Int.fromText("-5");
let f = myNat.toFloat();

let timestamp = Time.now();
let milliseconds = timestamp / 1_000_000;
```

`Time.now()` returns `Int` nanoseconds — use `Int` conversions, not `Time.compare`.
