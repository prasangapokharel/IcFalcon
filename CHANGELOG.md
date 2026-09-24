# Changelog

All notable changes to IcFalcon are documented here.

## [0.2.0] - 2026-09-24

### Added

- `icpsdkStandard` skill (`.agents/skills/icpsdkStandard/SKILL.md`) covering complete `@icp-sdk/core`, `@icp-sdk/auth`, and `@icp-sdk/signer` ecosystem
- `icpayControllerStandard` skill (`.agents/skills/icpayControllerStandard/SKILL.md`) for managing canister controllers via ICPay (icpay.app)
- Automated `mops` toolchain `moc` resolution in `ops/falcon` and `backend/scripts/run-tests.sh`
- Support for `--wasm-memory-persistence keep` on upgrade deploys for Motoko enhanced orthogonal persistence
- Official framework homepage linked at https://icpay.app/icfalcon

### Changed

- Migrated frontend from deprecated `@dfinity/*` packages to modern `@icp-sdk/core` and `@icp-sdk/auth`
- Streamlined `frontend/package.json` dependencies
- Set `--network ic` as default network target in `falcon` CLI (use `--local` for local replica)

## [0.1.0] - 2026-08-19

### Added

- Motoko backend with layered architecture (`api` → `service` → `repository` → `storage`)
- Next.js frontend with shadcn/ui (`base-maia` preset), dark theme, welcome page
- Global `falcon` CLI (`ops/falcon` + `falcon.yaml`) with scaffold, build, deploy, hub packages
- `falcon m:f <Name>` — Laravel-style module scaffolding
- icp-hub integration (`falcon add pkg`, `falcon p:list`, lock file `backend/icp.pkg`)
- Documentation under `docs/` (gettingStarted, backend, frontend, ops, packages, agents)
- AI agent skills under `.agents/skills/` (integration, frontend, Motoko, deploy)
- Internet Identity auth wiring on frontend
- 62 local `backend/pkg/` modules + hub registry support

### Changed

- Rebranded from icFrame to IcFalcon
- Renamed CLI from `icp` to `falcon`, config `falcon.yaml`
- `falcon s:init` installs frontend deps, all shadcn components, and runs static build

### Security

- Expanded `.gitignore` — excludes `node_modules`, `.mops`, `.dfx`, secrets, build output
- Removed vendored `backend/.mops` from version control
