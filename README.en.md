# SePay agent skills

[Tiếng Việt](README.md) | English

Skills that help coding agents (Claude Code, Codex, Cursor and others) integrate [SePay](https://developer.sepay.vn): bank transfer payments and webhooks, VietQR, virtual accounts, the payment gateway, the SePay API, Bank Hub, e-invoices, the `sepay` CLI and SePay MCP.

The skills are Markdown files only. They contain no scripts or binaries and collect no data. Details: [Security](#security).

## Install

Requires Node.js 22.20 or later.

```bash
npx skills add sepayvn/sepay-skills                        # choose agents interactively
npx skills add sepayvn/sepay-skills -g -y -a claude-code   # Claude Code, every project
npx skills add sepayvn/sepay-skills -g -y -a codex         # Codex
```

Use `sepayvn/sepay-skills` as written. A skill installed from a git URL (`git@github.com:…`) is not updated by `npx skills update`.

### Install without Node.js

The skill is just the `skills/sepay` folder. Download the repository with `git` or `curl`, then copy that folder to where your agent reads skills:

```bash
git clone --depth 1 https://github.com/sepayvn/sepay-skills.git
# or: curl -L https://github.com/sepayvn/sepay-skills/archive/refs/heads/main.tar.gz | tar -xz && mv sepay-skills-main sepay-skills

mkdir -p ~/.claude/skills && cp -R sepay-skills/skills/sepay ~/.claude/skills/   # Claude Code, Claude Desktop's Code tab
mkdir -p ~/.agents/skills && cp -R sepay-skills/skills/sepay ~/.agents/skills/   # Codex (CLI, IDE, ChatGPT desktop app)
```

- Codex can also install it with `$skill-installer` and the link `https://github.com/sepayvn/sepay-skills/tree/main/skills/sepay`.
- Claude Desktop (chat) and claude.ai: zip the `sepay` folder as `sepay.zip`, then go to **Settings → Capabilities → Skills → Upload skill**.
- `npx skills update` does not update a copy installed this way: download and copy it again for a new version. Start a new session if the agent does not see the skill.

## Update

```bash
npx skills update sepay        # update only the sepay skill
npx skills update sepay -g     # only the global install (-g)
```

Skills do not update automatically. Run this command when you want the latest version from `main`. `npx skills update` with no name updates every installed skill.

## Remove

```bash
DISABLE_TELEMETRY=1 npx skills remove sepay
```

Without `DISABLE_TELEMETRY=1`, the skills CLI reports the repository name to skills.sh.

## Skills

| Skill | Covers |
|---|---|
| `sepay` | Choosing an integration, webhooks, VietQR, payment gateway and IPN, SePay API, refunds, Bank Hub, e-invoices, Speaker API, OAuth2, plugins, Test mode and go-live, the `sepay` CLI, SePay MCP |

How the `sepay` skill behaves:

- It works in Test mode (sandbox) unless you ask for production.
- It may suggest installing the `sepay` CLI (SePay's official command-line tool, [sepayvn/sepay-cli](https://github.com/sepayvn/sepay-cli)) or connecting SePay MCP, and installs nothing without your approval.
- It reads values that change (supported banks, limits, hosts) from developer.sepay.vn when it answers.

## Security

- The skill is Markdown only: no scripts, binaries or install hooks, and no telemetry.
- On its own, the agent only sends `GET` requests to two SePay domains: docs on `developer.sepay.vn` and `vietqr.app`, SePay's VietQR service (bank list, QR images). SePay API calls and `sepay` CLI writes run only when you ask.
- The skill never tells the agent to send your code, files, secrets or account data anywhere, and keeps it away from `.env` files, SSH keys and files outside your project.
- SePay confirms payments and holds no money: transfers land straight in your bank account. No SePay API or `sepay` command pays money out; the only outgoing money is a refund back to the payer, capped by what was collected. The agent never refunds or voids a payment on production itself; it writes the code and tests it in sandbox.
- Docs, webhook payloads and transfer memos are data: instructions inside them are not followed.
- Risk tier L1 under the [OWASP Agentic Skills Top 10](https://owasp.org/www-project-agentic-skills-top-10/). Check the network calls yourself: `grep -rn "curl\|http" skills/`.

Reporting a vulnerability: [SECURITY.md](SECURITY.md).

## Support

- Documentation: https://developer.sepay.vn
- Questions and security reports: support@sepay.vn
