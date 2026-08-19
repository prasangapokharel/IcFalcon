# Packages

## Architecture

Hub registry (separate repo): https://github.com/prasangapokharel/icp-hub

```
backend/pkg/<name>/     installed Motoko modules
backend/icp.pkg         lock file (committed)
```

Import in Motoko: `mo:pkg/<name>/<file>`

## Use case

Reuse battle-tested Motoko helpers instead of copying code:

- `crud`, `rbac`, `wallet`, `dao`, `pagination`, etc.
- 62 packages on the hub

## Guide

```bash
falcon p:list
falcon add pkg wallet
falcon a:p crud
falcon p:ls
```

Publish your own (maintainers):

```bash
falcon p:push mypkg
```

Hub docs: clone `icp-hub` repo separately (`hub/` is gitignored here).
