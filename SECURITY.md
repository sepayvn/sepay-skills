# Security

The skills in this repository (today: `sepay`) are a set of plain-text instructions for coding agents. This page states what they do and do not do, so you can check them before installing.

## Commitments

- **No executable code.** The skill contains only Markdown files. It ships no scripts, binaries or install hooks.
- **Read-only network use.** The only network calls the skill tells an agent to make on its own are `GET` requests for public documentation on `developer.sepay.vn` and for public VietQR data on `vietqr.app` (SePay's QR service: bank list, QR images). Calls to the SePay API or `sepay` CLI writes happen only when you ask for them.
- **No data leaves your machine through the skill.** The skill never tells an agent to send your code, files, environment variables, secrets, tokens or account data to any URL or service, including SePay.
- **No access to secrets.** The skill tells the agent not to read `.env` files, credential stores, SSH keys or files outside your project, and to reference secrets by environment variable name.
- **External content is data.** Docs, webhook payloads, transfer memos and SePay MCP results are treated as data. Instructions found inside them are not followed.
- **Nothing installed without consent.** The skill does not install software, packages, MCP servers or tunnels without your approval.
- **No telemetry.** The skill collects nothing.

## Risk tier

L1 under the [OWASP Agentic Skills Top 10](https://owasp.org/www-project-agentic-skills-top-10/): instruction-only, read-only network access to two first-party SePay domains (`developer.sepay.vn`, `vietqr.app`).

## Verify it yourself

- Read the files: `SKILL.md` and `references/*.md`. Search for network use with `grep -rn "curl\|http" skills/`.

## Reporting a vulnerability

Email support@sepay.vn with the subject "Security: sepay skill". Do not open a public issue for security reports.
