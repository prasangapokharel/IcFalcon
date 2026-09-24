---
name: icpayControllerStandard
description: >-
  Canister controller management via ICPay (icpay.app) — adding dfx deployer principals,
  canister creation settings, and controller permissions. Read before mainnet deploy or
  when encountering "Caller is not a controller" errors.
---

# ICPay Canister Controller Standard

Manage canister controllers via [ICPay](https://icpay.app) to authorize local developer identities and CI deployers for mainnet builds and upgrades (`falcon b:deploy`).

---

## When to use

- Creating a new mainnet canister using ICPay wallet & Cycles Minting Canister (CMC)
- Authorizing your local `dfx` identity as a canister controller
- Authorizing team members or CI/CD runner principals
- Resolving `Caller is not a controller of the canister` deployment errors
- Checking or updating canister settings on ICPay

---

## Quick Setup Flow

```
Get CLI principal  →  Add to ICPay Controllers  →  Record Canister ID  →  Deploy with Falcon
dfx identity get-principal → icpay.app/canister/<id> → backend/canister_ids.json → falcon b:deploy
```

---

## 1. Retrieve your deployer principal

Find the principal ID of your active `dfx` identity:

```bash
dfx identity get-principal
```

*Example output:* `mrxi5-dk5go-zznk7-c3plw-gh34v-o26vu-a6577-z7e15-senix-cezfq-jqe`

---

## 2. Configure Controllers in ICPay

### Option A: During Canister Creation (`icpay.app/canister/create`)

1. Open [icpay.app/canister/create](https://icpay.app/canister/create).
2. Connect your ICPay wallet.
3. In the **Extra controllers** input field, paste your local principal:
   ```
   <your-dfx-principal>
   ```
4. Enter the ICP amount (cycles conversion handled automatically via CMC).
5. Click **Create from wallet**.
6. Note down the created Canister ID (e.g., `y5e5s-pyaaa-aaaa1-qxiha-cai`).

---

### Option B: On an Existing Canister (`icpay.app/canister/<canister-id>`)

1. Open `https://icpay.app/canister/<canister-id>`.
2. Click **Settings** → **Controllers**.
3. Under **Add New Controller**, paste your principal ID into the `Principal ID` input.
4. Click **Add Controller** and approve the transaction.
5. Verify your principal appears in the **Canister Controllers** list.

---

## 3. Wire Canister ID to IcFalcon

Set the production canister ID in `backend/canister_ids.json`:

```json
{
  "app": {
    "ic": "y5e5s-pyaaa-aaaa1-qxiha-cai"
  }
}
```

Also configure your production frontend environment (`frontend/.env.production` or host env):

```bash
NEXT_PUBLIC_CANISTER_ID_APP=y5e5s-pyaaa-aaaa1-qxiha-cai
NEXT_PUBLIC_DFX_NETWORK=ic
NEXT_PUBLIC_HOST=https://icp-api.io
```

---

## 4. Verify & Deploy

Verify controller status and ping the canister:

```bash
falcon c:info
falcon c:ping
```

Perform mainnet build and upgrade:

```bash
falcon b:test
falcon p:check
falcon b:deploy
```

---

## Controller Architecture & Rules

- **Multi-controller redundancy**: Keep at least one Internet Identity (ICPay web UI) controller and one CLI identity controller.
- **Never remove all controllers**: An empty controller list permanently freezes the canister.
- **Add before remove**: When rotating developer identities, add the new principal and test deployment before removing the old controller.
- **CI / Team principals**: Add dedicated CI deployment principals to ICPay controllers rather than sharing private keys.

---

## Related

| Topic | Path |
|---|---|
| Production deploy | [`guideStandard/productionDeployStandard/SKILL.md`](../guideStandard/productionDeployStandard/SKILL.md) |
| Local deploy | [`guideStandard/localDeployStandard/SKILL.md`](../guideStandard/localDeployStandard/SKILL.md) |
| Deploy reference | [`motokoStandard/deployGuideStandard/SKILL.md`](../motokoStandard/deployGuideStandard/SKILL.md) |
| CLI commands | [`ops/docs/commands.md`](../../../ops/docs/commands.md) |
