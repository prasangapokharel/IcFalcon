# Reserved Keywords

Motoko reserved words. **None** may be used as an identifier — variable, parameter,
function, type, field, or label. Check names before declaring, especially when a
domain term collides (`query`, `label`, `system`, `object`, `class`, `type`, `in`).

```text
actor        and          assert       async        await
break        case         catch        class        composite
continue     debug        debug_show   do           else
false        finally      flexible     for          from_candid
func         if           ignore       implicit     import
in           include      label        let          loop
mixin        module       not          null         object
or           persistent   private      public       query
return       shared       stable       switch       system
throw        to_candid    transient    true         try
type         var          while        with
```

`async*`, `await*`, and `await?` are also reserved.

Using a reserved word produces:

```text
syntax error [M0001], unexpected token '<name>', expected one of token or <phrase> sequence: ...
```

Rename rather than escape — no quoting mechanism. Conventional renames:
`query` → `request` / `searchTerm`, `label` → `caption` / `tag`,
`type` → `kind` / `category`, `object` → `item` / `entity`,
`class` → `group`.

## Not reserved

These read like keywords but are ordinary identifiers (often Candid keywords):

```text
blob    bool    char    int     nat     opt     record  service
struct  variant vec     enum    match   state   result  status
```
