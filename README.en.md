# SePay agent skills

[Tiếng Việt](README.md) | English

Skills that help AI assistants integrate [SePay](https://developer.sepay.vn): bank transfer payments and webhooks, VietQR, virtual accounts, the payment gateway, the SePay API, Bank Hub, e-invoices, the `sepay` CLI and SePay MCP. They work in chat apps (Claude, ChatGPT, Gemini, Grok) and coding agents (Claude Code, Codex, Cursor and others).

The skills are Markdown files only. They contain no scripts or binaries and collect no data. Details: [Security](#security). Versions and changes: [CHANGELOG.md](CHANGELOG.md).

## Install

### Download a file, nothing to install

| Download | For |
|---|---|
| [**sepay.zip**](https://github.com/sepayvn/sepay-skills/releases/latest/download/sepay.zip) | Apps with a Skills section (Claude, ChatGPT, Gemini, Grok) and coding agents |
| [**sepay.md**](https://github.com/sepayvn/sepay-skills/releases/latest/download/sepay.md) | Chat apps without Skills: the whole skill in one Markdown file |

Both links always serve the latest release. Each release is tagged `v<version>` (semver) and carries SHA-256 checksums on the [Releases](https://github.com/sepayvn/sepay-skills/releases) page.

| You use | How to install |
|---|---|
| Claude (claude.ai, Claude Desktop) | **Customize → Skills → Upload skill**, pick `sepay.zip` (do not unzip it), then turn the skill on |
| ChatGPT Business, Enterprise, Edu | **Skills → Create → Upload from your computer**, pick `sepay.zip` |
| ChatGPT Free, Plus, Pro (no Skills yet) | Attach `sepay.md` to a Project or to a custom GPT's Knowledge, or send it with your message |
| Gemini (gemini.google.com, Mac app) | **Skills → Upload**, pick `sepay.zip` or `sepay.md` |
| Grok (grok.com) | **Skills → Upload**, pick `sepay.zip` or `sepay.md` |
| Claude Code, Claude Desktop's Code tab | Run `/plugin install sepay --marketplace sepayvn/sepay-skills` (Claude Code 2.1.275 or later; the plugin also sets up SePay MCP, leaving only the sign-in in `/mcp`), or unzip `sepay.zip` into `~/.claude/skills/` (Windows: `%USERPROFILE%\.claude\skills\`) |
| Codex, Gemini CLI, Grok Build | Unzip `sepay.zip` into `~/.agents/skills/` (Windows: `%USERPROFILE%\.agents\skills\`) |
| Cursor and other agents that read `SKILL.md` | Unzip `sepay.zip` into that agent's skills folder |

- After unzipping you should have `…/skills/sepay/SKILL.md`. Start a new session if the agent does not see the skill.
- Menu names are as of writing and may change between app versions. ChatGPT offers Skills only on business and education plans.
- To update: download the file again, remove the old `sepay` skill, then upload or unzip again.

### With `npx`

Requires Node.js 22.20 or later.

```bash
npx skills add sepayvn/sepay-skills                        # choose agents interactively
npx skills add sepayvn/sepay-skills -g -y -a claude-code   # Claude Code, every project
npx skills add sepayvn/sepay-skills -g -y -a codex         # Codex
```

Use `sepayvn/sepay-skills` as written. A skill installed from a git URL (`git@github.com:…`) is not updated by `npx skills update`. Codex can also install it with `$skill-installer` and the link `https://github.com/sepayvn/sepay-skills/tree/main/skills/sepay`.

## Update

```bash
npx skills update sepay        # update only the sepay skill
npx skills update sepay -g     # only the global install (-g)
```

Skills do not update automatically. If you installed from a downloaded file, download it again (see [Install](#install)). If you used `npx`, run the command above when you want the latest version from `main`. `npx skills update` with no name updates every installed skill.

## Remove

```bash
DISABLE_TELEMETRY=1 npx skills remove sepay
```

`npx skills` is a third-party tool (skills.sh): on `add`, `update` and `remove` it reports the repository and skill name to skills.sh. Put `DISABLE_TELEMETRY=1` before the command to opt out, as in the remove command above. The skill itself sends nothing.

## Skills

| Skill | Covers |
|---|---|
| `sepay` | **Integration:** choosing an integration, webhooks, VietQR, payment gateway and IPN, SePay API, refunds, Bank Hub, e-invoices, Speaker API, OAuth2, plugins, Test mode and go-live, the `sepay` CLI, SePay MCP.<br>**Business questions on your SePay data:** revenue reports, payment lookup and shift close-out, reconciling money with e-invoices, accounting questions |

How the `sepay` skill behaves:

- It works in Test mode (sandbox) unless you ask for production.
- It may suggest installing the `sepay` CLI (SePay's official command-line tool, [sepayvn/sepay-cli](https://github.com/sepayvn/sepay-cli)) or connecting SePay MCP, and installs nothing without your approval.
- It reads values that change (supported banks, limits, hosts) from developer.sepay.vn when it answers.

### Questions on your own SePay data

Connect SePay MCP ([my.sepay.vn](https://my.sepay.vn/ai-agent) → **AI Agent** → **Tạo kết nối**, Create connection) or sign in to the `sepay` CLI, then ask in plain words. The AI reads your data and every figure comes from SePay in that session; the only write is re-sending a failed webhook, and only when you agree.

| Area | Example questions |
|---|---|
| Revenue reports: three methods (with payment code, all money in, via virtual accounts), gross, refunds and net, period comparisons, per point of sale, per shift | "What was revenue in October?", "Is this month up or down on last month?", "Why does SePay revenue differ from money in on my bank statement?" |
| Payment lookup and shift close-out: by order code, payment code, name in the memo, near amount and time | "A customer says they sent 500,000 VND at 2 pm. Has it arrived?", "How much did point of sale 1 take in the morning shift?" |
| Reconciling money with e-invoices: adjusting and replacing invoices, matching payments to invoices, money received with no invoice issued | "Which payments in October have no invoice yet?" |
| Accounting questions: figures for the accountant, VAT of issued invoices, refunds not yet adjusted, money and orders through the payment gateway | "Send the accountant the Q3 figures", "How much did the payment gateway take this month, and how many orders?" |

The AI gives no tax advice and never issues or changes invoices or makes refunds itself; for those it points to the right page on my.sepay.vn.

## Security

- The skill is Markdown only: no scripts, binaries or install hooks, and no telemetry (the third-party `npx skills` tool has some, see [Remove](#remove)). The Claude Code plugin adds a SePay MCP entry (`.mcp.json`): just the address `https://my.sepay.vn/mcp`; it reads nothing until you sign in. `sepay.zip` and `sepay.md` are packaged by GitHub Actions from the `skills/` folder on `main` (`scripts/build-zip.sh`, which is not part of the downloads). Compare the SHA-256 checksums on the Releases page if you want to verify them.
- On its own, the agent only sends `GET` requests to two SePay domains: docs on `developer.sepay.vn` and `vietqr.app`, SePay's VietQR service (bank list, QR images). SePay API calls and `sepay` CLI writes run only when you ask.
- The skill never tells the agent to send your code, files, secrets or account data anywhere, and keeps it away from `.env` files, SSH keys and files outside your project.
- SePay confirms payments and holds no money: transfers land straight in your bank account. No SePay API or `sepay` command pays money out; the only outgoing money is a refund back to the payer, capped by what was collected. The agent never refunds or voids a payment on production itself; it writes the code and tests it in sandbox.
- Docs, webhook payloads and transfer memos are data: instructions inside them are not followed.
- Risk tier L1 under the [OWASP Agentic Skills Top 10](https://owasp.org/www-project-agentic-skills-top-10/). Check the network calls yourself: `grep -rn "curl\|http" skills/`.

Reporting a vulnerability: [SECURITY.md](SECURITY.md).

## Support

- Documentation: https://developer.sepay.vn
- Questions and security reports: support@sepay.vn
