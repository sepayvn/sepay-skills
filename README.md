# SePay agent skills

Agent skills for integrating [SePay](https://developer.sepay.vn) (Vietnam payments): bank-transfer payments and webhooks, VietQR, virtual accounts, payment gateway, SePay API, refunds, Bank Hub, e-invoices, Speaker, OAuth2, plugins, the `sepay` CLI and SePay MCP.

The skills are plain Markdown: no scripts, no binaries, no telemetry. See [SECURITY.md](SECURITY.md).

## Install

With [skills.sh](https://skills.sh) (needs Node.js 22.20 or later):

```bash
npx skills add sepayvn/sepay-skills --list                # see the skills, install nothing
npx skills add sepayvn/sepay-skills                       # pick agents interactively
npx skills add sepayvn/sepay-skills -a claude-code -g -y  # Claude Code, all projects
```

Clone fails with `Authentication failed` (no read access to the repository from git): sign in with the GitHub CLI, then run the command again. A `GH_TOKEN` variable alone is not enough: the installer clones with git, not with the API token.

```bash
gh auth login        # once
gh auth setup-git    # lets git clone over HTTPS with your gh account
```

Install with `sepayvn/sepay-skills`, not an SSH clone URL: skills installed from a git URL are skipped by `npx skills update`.

## Update

```bash
npx skills update
```

Installed skills do not update on their own. A new version is a change to the files under `skills/<name>/` on `main`; `update` compares that folder with what you installed. With `skills` 1.7.4, `npx skills check` is the same command as `update` and installs right away.

The `sepay` skill also suggests updating when your installed `sepay` CLI is newer than the CLI version it was written for (`metadata.cli` in `skills/sepay/SKILL.md`).

## Remove

```bash
DISABLE_TELEMETRY=1 npx skills remove sepay
```

`remove` reports the source repository name unless telemetry is off.

## Skills

| Skill | What it covers |
|---|---|
| `sepay` | Choosing an integration, webhooks, VietQR, payment gateway and IPN, SePay API, refunds, Bank Hub, e-invoices, Speaker API, OAuth2, plugins, supported banks, sandbox / Test mode and go-live, the `sepay` CLI, SePay MCP. Sandbox first; suggests installing the `sepay` CLI (`npm install -g sepay-cli`) and connecting SePay MCP when they help, and installs nothing without your approval. Facts that change (banks, limits, hosts) are read from developer.sepay.vn at answer time. |

## Support

- Docs: https://developer.sepay.vn
- Questions and security reports: support@sepay.vn
