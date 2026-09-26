# icp-hub Package Ecosystem

**icp-hub** is the community package registry for the Internet Computer, integrated directly into the `falcon` CLI (similar to `go get` or `cargo add`).

Registry: [github.com/prasangapokharel/icp-hub](https://github.com/prasangapokharel/icp-hub)

---

## 1. Package Commands

```bash
# List all available hub packages
falcon p:list

# Install a package into backend/pkg/
falcon add pkg <name>

# Short alias
falcon a:p <name>

# List installed packages in current project
falcon p:ls

# Publish a package to the hub registry
falcon p:push <name>
```

When you install a package, `falcon add pkg` automatically resolves dependencies, copies the source files into `backend/pkg/<name>/`, and records the installation in `backend/icp.pkg`.

---

## 2. Featured Packages

### Core Architecture & State
- **`universe`**: Event-driven multi-canister mesh ("Kafka for Motoko") with outbox & inbox deduplication.
- **`crud`**: Generic Map CRUD helpers for `mo:core`.
- **`storage`**: Generic stable Map store wrappers.
- **`indexer`**: Secondary index manager for fast multi-key queries.
- **`pagination`**: Page type, limit/offset slicing, and cursor helpers.

### Financial & Payments
- **`wallet`**: Custodial wallet account derivation and deposit addresses.
- **`transfer`**: ICRC transfer argument builders, pre-flight fee checks, and transaction records.
- **`transaction`**: Immutable transaction log schema and query index.
- **`icrc1` & `icrc2`**: ICRC-1/2 token types, transfer_from builders, and balance checks.
- **`ckbtc`**: ckBTC token reference, satoshi math, and Bitcoin address validation.
- **`escrow`**: Hold/release escrow payment state machine.

### Authentication & Security
- **`caller`**: Principal validation and effective caller resolution.
- **`rbac`**: Role-based access control and permission checking.
- **`rate-limit`**: Per-principal sliding window rate limiting.
- **`api-key`**: Secure API key generation and validation.
- **`whitelist`**: Principal allow/deny list management.
- **`vetkeys`**: vetKD encryption and decryption request types.

### Connectors & Integrations
- **`openai`**: OpenAI API configuration and ChatCompletion payload builders.
- **`stripe`**: Stripe checkout session builders and webhook validation.
- **`google-mail`**: Gmail API URL and raw MIME email helpers.
- **`google-calendar`**: Google Calendar API URL and event helpers.
- **`slack`**: Slack `chat.postMessage` webhook builders.
- **`telegram`**: Telegram Bot API `sendMessage` helpers.
- **`resend` & `sendgrid`**: Transactional email payload builders.

---

## 3. Importing Installed Packages

All packages are imported using the `"mo:pkg/<name>/<entry>"` syntax:

```motoko
import Universe "mo:pkg/universe/universe";
import Wallet "mo:pkg/wallet/wallet";
import Transfer "mo:pkg/transfer/transfer";
import Errors "mo:pkg/errors/result";
```
