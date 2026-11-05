# The `sepay` CLI

Optional. Every integration works with code + the my.sepay.vn dashboard; the CLI is a shortcut for setup, sandbox testing and inspecting data. Commands read `sepay <noun> <verb>`.

## Install

Every channel ships the same signed release build. Pick by what the machine already has (OS and tools detected as in `SKILL.md` › Tools worth suggesting), in the table's order; ask the user only when more than one fits (`SKILL.md` Rule 10).

| Machine | Install | Upgrade |
|---|---|---|
| macOS with Homebrew | `brew install sepayvn/sepay-cli/sepay` | `brew upgrade sepay` |
| Windows with Scoop | `scoop bucket add sepay https://github.com/sepayvn/scoop-sepay-cli` then `scoop install sepay` | `scoop update sepay` |
| Node.js (any OS) | `npm install -g sepay-cli` | `npm install -g sepay-cli@latest` |
| Go | `go install github.com/sepayvn/sepay-cli/cmd/sepay@latest` | run it again |
| macOS / Linux, none of the above | `curl -fsSL https://get.sepay.vn/sepay-cli-install.sh \| sh` (not Windows) | run it again |

- The install script needs no sudo: it puts `sepay` in `~/.local/bin` (`SEPAY_INSTALL_DIR` changes it, `SEPAY_VERSION=x.y.z` pins a version), checks the archive's SHA-256, and also its cosign signature when `cosign` is on PATH. Tell the user it downloads and runs a script before you run it.
- npm is the channel that always works. If a Homebrew, Scoop, script or `go install` command fails (tap / bucket not found, 404, unknown module), say so in one line and use npm.
- Teams and CI pin the version in the project instead:

```bash
npm install --save-dev sepay-cli      # records the exact version in the lockfile
npx sepay --version
npm ci --ignore-scripts               # CI: the package ships no install scripts
```

Upgrade with the channel `sepay` came from, read from its resolved path (`readlink -f "$(command -v sepay)"`): `node_modules` → npm (in a project `npm install -D sepay-cli@latest`), `Caskroom` / `Cellar` → Homebrew, `scoop/apps` → Scoop, `go/bin` → `go install`, anything else → the install script. When to suggest installing or upgrading: `SKILL.md` › Tools worth suggesting. Not installed and the user does not want it: do the task with code / dashboard instead, do not insist.

Stable releases are on the npm `latest` dist-tag (the default). `next` holds release candidates (`x.y.z-rc.N`): install `sepay-cli@next` (or `SEPAY_VERSION=x.y.z-rc.N` with the script) only when the user wants to try one. Homebrew and Scoop carry stable releases only.

## Learn the surface from the CLI itself, not from memory

- `sepay --map=json`: every command as metadata, incl. which are sandbox-only, which **confirm**, which are **destructive** (cannot be undone), and the scope each needs. Read it before running an unfamiliar write.
- `sepay <command> --help`: flags plus an `[Agent guidance]` block for agents.
- `sepay docs <topic>`: offline docs matching the installed version: `overview`, `flows` (order of commands per task), `api`, `environment`, `errors`, `exit-codes`, `glossary`, `webhook-payload`, `ipn-payload`.

## Auth and environment

- `sepay login` (browser device code), `sepay auth status` (which account / company). No browser: `sepay login --with-token` (pipe a refresh token). No env var supplies a token, by design.
- Widen scopes: `sepay auth refresh --scopes <scope>`.
- `--env sandbox|production`; **default sandbox**. Use production only when the user asks.
- `--profile` / `SEPAY_PROFILE` picks an account. When an agent runs next to the user's session, set `SEPAY_CONFIG_DIR` to a scratch dir so it cannot touch the user's logged-in profile.

## Running commands safely

- Read / list commands: add `--json` and parse the output; never scrape tables.
- Writes that confirm exit 2 with `requires confirmation; pass --yes` when there is no terminal. Pass `--yes` only after the user confirmed the exact list of changes you showed them (SKILL.md Rule 2); a `--yes` or "don't ask" in the original request does not count. `--yes` never bypasses an OTP.
- Destructive or production writes: list what will change, stop, wait for that confirmation. Production webhooks never use `--auth-type none`.
- Secrets go in on stdin (`--secret -`, e.g. `printf %s "$SEPAY_WEBHOOK_SECRET" | sepay webhook create … --secret -`), never as an argument: arguments land in shell history and `ps`.
- Do not print API keys: `apikey` list / get output is masked; `create` prints the new key once, so do not echo it back into the chat or logs.

## Exit codes

| Code | Meaning | Do |
|---|---|---|
| 0 | success | |
| 1 | server error or rejected field | read the message before retrying |
| 2 | bad flags / arguments / unknown command, or confirmation needed | fix the command; do not blind-retry |
| 3 | command has no backend | do not retry |
| 4 | not authenticated | `sepay login` (the user does it) |
| 5 | missing scope | `sepay auth refresh --scopes <scope>` |
| 6 | your local handler rejected a forwarded event | fix the handler |
| 7 | server demanded an OTP | do it in the web app |
| 8 | account / company not allowed | someone else must act (enable CLI, Test mode, permission) |

Confirm with `sepay docs exit-codes` for the installed version.

## Common tasks

| Task | Start with |
|---|---|
| Set up a sandbox | `sepay sandbox init` (`--with-va`, `--with-webhook-listen`, `--seed N`; when not interactive pass every flag or `--yes`), see `testing-go-live.md` › Test mode |
| See incoming money | `sepay bank-account list`, `sepay transaction list --json` |
| Create a webhook that confirms orders: `--event-type in --verify-payment`, no `--skip-if-no-code` / `--prefix-filter` unless asked (`webhook.md` step 5); localhost while developing | `sepay webhook create`, `sepay webhook listen` |
| Test a handler | `sepay webhook test`; `sepay sandbox simulate payment_in --amount 50000 --bank-account <xid> --code DH123` (xid from `sepay bank-account list --json`) |
| Per-order matching | `sepay paycode get / set / create`, `sepay va issue` |
| Hosted checkout order | `sepay pg checkout init` |
| App credential | `sepay apikey create` (sandbox) |
| Bank Hub / e-invoice | `sepay bankhub …`, `sepay einvoice …` |
| Endpoint without a command | `sepay api /v2/...` |

Exact order per task: `sepay docs flows`.

## Pay-code structures

- `sepay paycode get`: the on/off switch and every structure (prefix, suffix range, character type, active).
- `sepay paycode set [prefix]`: edits one structure (`--structure <prefix>` picks which) and keeps the rest; flags you leave out keep the stored value; `--enable` / `--disable` toggle detection. It sends the version it read, so a concurrent change fails with a conflict: run `get` again instead of forcing.
- `sepay paycode create <prefix> --suffix-from N --suffix-to M --character-type NumberOnly|NumberAndLetter --active` (or `--active=false`): adds a structure at the end, all flags required; a prefix the company already has, in any case, is refused. If `sepay paycode --help` lists no `create`, add it in my.sepay.vn instead.
- Prefix 2-5 letters, suffix bounds 1-30. On production both writes change matching immediately (transfers already sent with an old prefix stop matching), so they confirm first (Rule 2).

Reference for the installed version: `sepay docs` and `sepay <command> --help`.
