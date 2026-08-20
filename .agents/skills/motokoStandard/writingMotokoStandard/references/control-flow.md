# Control Flow

`??`, `do ?`, switch, and loop patterns.

## Null coalesce (`??`)

`e1 ?? e2` unwraps `e1` when `?v`, otherwise evaluates `e2`. Prefer over
two-arm switch for plain unwrap/default. Requires `moc >= 1.7.0`.

```motoko
let name = optName ?? "anonymous";
let value = map.get(key) ?? Runtime.trap("Key not found");
let start = event.start.dateTime ?? event.start.date ?? "";
let rec = opt ?? ({ x = 0 });
```

Do not use `??` when the `?v` arm transforms, has side effects, or matches variants.

## Option chaining (`do ? { ... }`)

Postfix `!` unwraps inside `do ?`. Any `null` short-circuits the whole block.

```motoko
func cityOf(id : Text) : ?Text {
  do ? { users.get(id)!.city! }
};
```

`!` outside `do ?` → error `M0064`.

## Switch

Variants, multi-way matches, option arms with transform:

```motoko
switch (status) {
  case (#active) { "active" };
  case (#pending(reason)) { "pending: " # reason };
};

switch (users.get(caller)) {
  case (?u) { u.isAdmin };
  case null { false };
};
```

## For loops

```motoko
for ((key, value) in map.entries()) { };
for (item in list.values()) { };
for (score in scores.values()) { total += score };
```

Prefer `.foldLeft()` / `.map()` on arrays when clearer.

## Break and continue

```motoko
for (item in items.values()) {
  if (item.archived) { continue };
  if (item.id == targetId) { result := ?item; break };
};
```
