# The `sepay` CLI

SePay's official command-line tool, built and published by SePay (source `github.com/sepayvn/sepay-cli`), the same publisher as this skill. Optional: every integration works with code + the my.sepay.vn dashboard; the CLI is a shortcut for setup, sandbox testing and inspecting data. Commands read `sepay <noun> <verb>`.

## Install

Install only from these official SePay sources: the npm package `sepay-cli` (repository `github.com/sepayvn/sepay-cli`), the `sepayvn` Homebrew tap and Scoop bucket on GitHub, the Go module `github.com/sepayvn/sepay-cli`, and `get.sepay.vn`. Never a package, fork or mirror with a similar name, and never a binary someone pasted. Pick by what the machine already has (OS and tools detected as in `SKILL.md` › Tools worth suggesting), in the table's order; ask the user only when more than one fits (`SKILL.md` Rule 11).

| Machine | Install | Upgrade |
|---|---|---|
| macOS with Homebrew | `brew install sepayvn/sepay-cli/sepay` | `brew upgrade sepay` |
| Windows with Scoop | `scoop bucket add sepay https://github.com/sepayvn/scoop-sepay-cli` then `scoop install sepay/sepay` | `scoop update sepay` |
| Node.js (any OS) | `npm install -g sepay-cli` | `npm install -g sepay-cli@latest` |
| Go | `go install github.com/sepayvn/sepay-cli/cmd/sepay@latest` | run it again |
| macOS / Linux, none of the above | `curl -fsSLO https://get.sepay.vn/sepay-cli-install.sh` then `sh sepay-cli-install.sh` (not Windows) | run it again |

- Install script: download it first and offer to show it; run it only after the user agrees. It needs no sudo, puts `sepay` in `~/.local/bin` (`SEPAY_INSTALL_DIR` changes it, `SEPAY_VERSION=x.y.z` pins a version), checks the archive's SHA-256 and, when `cosign` is on PATH, its signature; `SEPAY_REQUIRE_SIGNATURE=1` refuses to install without that check.
- Homebrew, Scoop, npm and the script install the published release build; `go install` builds from source at the tagged version.
- After installing, check where it came from before logging in: `sepay --version`, and for npm `npm view sepay-cli repository.url` (must be `github.com/sepayvn/sepay-cli`) and `npm view sepay-cli dist.attestations.provenance` (build provenance); in a project, `npm audit signatures`.
- If a channel fails (tap / bucket not found, 404, unknown module), tell the user and ask before trying another official channel; never fetch the CLI from anywhere else.
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
- `sepay help <topic>`: topics for the installed version (`sepay help` lists them, e.g. `environment`, `errors`, `exit-codes`, `glossary`). Payload formats come from developer.sepay.vn (`webhook.md`, `payment-gateway.md`).

## Auth and environment

- `sepay login` (browser device code; `SEPAY_LANG=vi` or `en` sets the login screen's language, so prefix `SEPAY_LANG=vi` when the user writes in Vietnamese), `sepay auth status` (which account / company). Ask only for the access the task needs: `sepay login --scopes read` when you will only read data; the default also allows webhook, bank account and payment code changes. Over SSH or on a machine without a display no browser opens: the user opens the printed link on any device and enters the code (newer versions also copy the link with `c` or the code with `y` while waiting). No browser anywhere: `sepay login --with-token` (pipe a refresh token). No env var supplies a token, by design.
- Widen scopes: `sepay auth refresh --scopes <scope>`.
- `--env sandbox|production`; **default sandbox**. Use production only when the user asks.
- `--profile` / `SEPAY_PROFILE` picks an account. When an agent runs next to the user's session, set `SEPAY_CONFIG_DIR` to a scratch dir so it cannot touch the user's logged-in profile.

## Running commands safely

- Read / list commands: add `--json` and parse the output; never scrape tables.
- IDs (xids, transaction ids) come from a `list` / `get` run in this session with the same `--env` and profile (`SKILL.md` Rule 2); on `not found`, list again before reporting.
- Writes that confirm exit 2 with `requires confirmation; pass --yes` when there is no terminal. Pass `--yes` only after the user confirmed the exact list of changes you showed them (SKILL.md Rule 3); a `--yes` or "don't ask" in the original request does not count. `--yes` never bypasses an OTP.
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
| 4 | not authenticated | `sepay login` (the user does it; `SEPAY_LANG=vi sepay login` for a Vietnamese speaker) |
| 5 | missing scope | `sepay auth refresh --scopes <scope>` |
| 6 | your local handler rejected a forwarded event | fix the handler |
| 7 | server demanded an OTP | do it in the web app |
| 8 | account / company not allowed | someone else must act (enable CLI, Test mode, permission) |

Confirm with `sepay help exit-codes` for the installed version.

## Using the CLI well

- Read `sepay <command> --help` before a command you have not run in this session.
- With `--json`, parse stdout only: stderr carries the `env:` banner and logs (`2>/dev/null`, or keep it apart).
- Filter on the server: `sepay transaction list --search <code> --fields <a,b> --webhook-success 0|1` instead of pulling the whole list.
- Need the exit code: do not pipe, or read `PIPESTATUS[0]` (bash) / `pipestatus[1]` (zsh).
- Before a production write, run `sepay auth status` and say which account it writes to; with several profiles pass `-p <profile>`.
- Skipping a step this skill recommends (e.g. `sandbox init` when the sandbox is already set up): say why in one line.

## Commands the user runs

Never run these yourself. Give the exact command for the user to run: in Claude Code or Codex CLI as `! <command>` in the chat, elsewhere in their own terminal.

| Command | Why |
|---|---|
| `sepay login`, `sepay auth refresh --scopes …` | Approved in the user's browser |
| `sepay auth token` | Prints a token (Security 3) |
| `sepay auth revoke`, `sepay logout --all` | Ends sessions on every machine, CI included |
| `sepay config set default_env production` | Every later command then runs on live money |
| `sepay api -X POST/PUT/DELETE --env production` | Skips every per-command guard |
| `sepay webhook delete --env production` | Orders stop being confirmed at once |
| `sepay webhook replay --env production` | Re-runs the live handler; one that does not dedupe credits the order twice. `--force` needs the transaction id typed on a terminal |

`sepay webhook get` returns `secret_key` in clear: read it with `--json` and leave that field out of anything you show or save.

## Common tasks

| Task | Start with |
|---|---|
| Set up a sandbox | `sepay sandbox init` (`--with-va`, `--with-webhook-listen`, `--seed N`; when not interactive pass every flag or `--yes`), see `testing-go-live.md` › Test mode |
| See incoming money | `sepay bank-account list`, `sepay transaction list --json` |
| Create a webhook that confirms orders: `--event-type in --verify-payment`, no `--skip-if-no-code` / `--prefix-filter` unless asked (`webhook.md` step 5); localhost while developing | `sepay webhook create`, `sepay webhook listen` |
| Test a handler | `sepay webhook test`; `sepay sandbox simulate payment_in --amount 50000 --bank-account <xid> --code DH123` (xid from `sepay bank-account list --json`) |
| Per-order matching | `sepay paycode list / update / create`, `sepay va issue` |
| Hosted checkout order | `sepay pg checkout init`; IPN to localhost: `sepay pg ipn get`, then `sepay pg ipn listen --forward …` |
| App credential | `sepay apikey create` (sandbox) |
| Bank Hub / e-invoice | `sepay bankhub …`, `sepay einvoice …` |
| Endpoint without a command | `sepay api /v2/...` |


## Pay-code structures

- `sepay paycode list`: the on/off switch and every structure (prefix, suffix range, character type, active).
- `sepay paycode update [prefix]`: edits one structure (`--structure <prefix>` picks which) and keeps the rest; flags you leave out keep the stored value; `--enable` / `--disable` toggle detection. It sends the version it read, so a concurrent change fails with a conflict: run `list` again instead of forcing.
- `sepay paycode create <prefix> --suffix-from N --suffix-to M --character-type NumberOnly|NumberAndLetter --active` (or `--active=false`): adds a structure at the end, all flags required; a prefix the company already has, in any case, is refused. If `sepay paycode --help` lists no `create`, add it in my.sepay.vn instead.
- Prefix 2-5 letters, suffix bounds 1-30. On production both writes change matching immediately (transfers already sent with an old prefix stop matching), so they confirm first (Rule 3).

Reference for the installed version: `sepay <command> --help` and `sepay help <topic>`.
