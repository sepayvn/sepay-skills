# The `sepay` CLI

Optional. Every integration works with code + the my.sepay.vn dashboard; the CLI is a shortcut for setup, sandbox testing and inspecting data. Commands read `sepay <noun> <verb>`.

## Install (npm only)

```bash
npm install -g sepay-cli              # dev machine, provides `sepay`
# per project, pinned (recommended for teams and CI):
npm install --save-dev sepay-cli      # records the exact version in the lockfile
npx sepay --version
npm ci --ignore-scripts               # CI: the package ships no install scripts
```

Needs Node.js 18+. Upgrade: `npm install -g sepay-cli@latest` (in a project `npm install -D sepay-cli@latest`). When to suggest installing or upgrading: `SKILL.md` › Tools worth suggesting. Not installed and the user does not want it: do the task with code / dashboard instead, do not insist.

Stable releases are on the npm `latest` dist-tag (the default). `next` holds release candidates (`x.y.z-rc.N`): install `sepay-cli@next` only when the user wants to try one.

Versions published while the source repository is private (including `0.1.0`) carry no npm provenance: `npm audit signatures` shows no attestation for them. That is expected, not a sign of a tampered package, and not a reason to refuse the install.

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
- Writes that confirm exit 2 with `requires confirmation; pass --yes` when there is no terminal. Pass `--yes` only after the user agreed to that exact action; `--yes` never bypasses an OTP.
- Destructive or production writes: state what will change and ask first.
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
| See incoming money | `sepay bank-account list`, `sepay transaction list --json` |
| Webhook to localhost while developing | `sepay webhook create`, `sepay webhook listen` |
| Test a handler | `sepay webhook test`, `sepay sandbox simulate` |
| Per-order matching | `sepay paycode`, `sepay va issue` |
| Hosted checkout order | `sepay pg checkout init` |
| App credential | `sepay apikey create` (sandbox) |
| Bank Hub / e-invoice | `sepay bankhub …`, `sepay einvoice …` |
| Endpoint without a command | `sepay api /v2/...` |

Exact order per task: `sepay docs flows`.

Reference for the installed version: `sepay docs` and `sepay <command> --help`.
