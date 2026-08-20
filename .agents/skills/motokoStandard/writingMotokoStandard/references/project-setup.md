# Project Setup — Compiler Flags

One-time `backend/mops.toml` settings for IcFalcon Motoko projects.

IcFalcon template already sets these — only edit when bootstrapping manually.

## Persistence

```toml
[moc]
args = ["--default-persistent-actors"]
```

Enhanced orthogonal persistence is default. This flag makes plain `actor { }`
persistent without the `persistent` keyword.

Without it:

```text
M0219 — implicitly transient, declare `transient`
M0220 — should be declared `persistent`
```

Fallback: write `persistent actor { ... }` in `main.mo`.

## Style warnings

```toml
[moc]
args = ["--default-persistent-actors", "-W", "M0236,M0237,M0223"]
```

| Code | Rule |
|---|---|
| M0236 | Non-dot-notation calls |
| M0237 | Redundant explicit implicit args |
| M0223 | Redundant type instantiation |

Run `mops check --fix` to auto-correct when warnings are enabled.

## IcFalcon verify

```bash
falcon b:test --local
```

Confirms `mops.toml` flags and backend compile together.
