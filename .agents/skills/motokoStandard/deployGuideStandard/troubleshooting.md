# Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `dfx build` fails on migration | Record shape changed without migration | [`../../migrationStandard/SKILL.md`](../../migrationStandard/SKILL.md) |
| `moc` version mismatch | Wrong compiler | `falcon s:init` |
| `mops` package not found | Lock out of date | `cd backend && mops install` |
| Frontend calls fail locally | Wrong canister id / no root key | Check `.env.local`, `fetchRootKey()` |
| Deploy traps on upgrade | Bad migration or transient storage | Check storage is not `transient` in `persistent actor` |
| `falcon: command not found` | CLI not installed | `./ops/install.sh` |
| Mainnet deploy blocked | No TTY | Run deploy in interactive terminal |
| Zero tests reported | Wrong test runner | Use `backend/testing/`, not `mops test` |

## Logs

```bash
falcon b:logs --local
falcon b:logs
```

## Clean local state

```bash
falcon r:stop
cd backend && dfx start --clean --background
falcon b:deploy --local
```

## More help

- [`../../../../ops/docs/commands.md`](../../../../ops/docs/commands.md)
- [`../writingMotokoStandard/SKILL.md`](../writingMotokoStandard/SKILL.md)
