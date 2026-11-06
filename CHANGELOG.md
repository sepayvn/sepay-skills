# Nhật ký thay đổi

Tiếng Việt | [English](#changelog)

Phiên bản theo [semver](https://semver.org/lang/vi/). Số phiên bản nằm ở `.claude-plugin/plugin.json` và `metadata.version` trong `skills/sepay/SKILL.md`. Mỗi bản có tag `v<phiên bản>` trên trang [Releases](https://github.com/sepayvn/sepay-skills/releases), kèm `sepay.zip`, `sepay.md` và `SHA256SUMS`.

## [1.0.1] - 2026-11-06

### Thêm

- Dùng được trong ứng dụng chat không có terminal (claude.ai, Claude Desktop, ChatGPT, Gemini, Grok): AI đọc tài liệu SePay bằng công cụ tải trang hoặc SePay MCP, hướng dẫn thao tác trên my.sepay.vn thay cho lệnh `sepay`, giao code dưới dạng file và hướng dẫn bạn thử bằng **Mô phỏng giao dịch**.
- Plugin Claude Code cài kèm SePay MCP (`https://my.sepay.vn/mcp`): cài plugin xong chỉ cần đăng nhập trong `/mcp`, không phải tự nhập Client ID.
- Câu hỏi chọn ngôn ngữ / framework có thêm lựa chọn **Chọn giúp tôi**.
- Skill biết phiên bản của mình và cách cập nhật theo từng cách cài (plugin, `npx`, file tải về).

### Thay đổi

- Người hỏi từ ứng dụng chat hoặc dự án trống, chỉ mô tả kết quả muốn có (ví dụ "làm cho web tự xác nhận chuyển khoản"), được trả lời bằng ngôn ngữ dễ hiểu ngay từ đầu.
- README ghi rõ công cụ `npx skills` (bên ngoài, của skills.sh) gửi tên repo về skills.sh và cách tắt; bản thân skill không gửi gì.

### Sửa

- Lệnh cài `sepay` CLI qua Scoop: `scoop install sepay/sepay`, khớp tài liệu CLI.

## [1.0.0] - 2026-11-06

Bản đầu tiên có số phiên bản.

- Skill `sepay`: chọn cách tích hợp, webhook, VietQR, tài khoản ảo (VA), cổng thanh toán và IPN, SePay API, đối soát và hoàn tiền, Bank Hub, hóa đơn điện tử, loa thanh toán, OAuth2, plugin, Test mode và go-live, `sepay` CLI, SePay MCP.
- File tải về `sepay.zip` và `sepay.md` cho ứng dụng có mục Skills và ứng dụng chat.
- Đóng gói thành plugin Claude, cài bằng `/plugin install sepay --marketplace sepayvn/sepay-skills`.

[1.0.1]: https://github.com/sepayvn/sepay-skills/releases/tag/v1.0.1

---

# Changelog

[Tiếng Việt](#nhật-ký-thay-đổi) | English

Versions follow [semver](https://semver.org). The version lives in `.claude-plugin/plugin.json` and in `metadata.version` of `skills/sepay/SKILL.md`. Each release is tagged `v<version>` on the [Releases](https://github.com/sepayvn/sepay-skills/releases) page and ships `sepay.zip`, `sepay.md` and `SHA256SUMS`.

## [1.0.1] - 2026-11-06

### Added

- Works in chat apps without a terminal (claude.ai, Claude Desktop, ChatGPT, Gemini, Grok): the AI reads SePay docs with a page-fetch tool or SePay MCP, guides you through my.sepay.vn instead of `sepay` commands, hands over code as files and has you test with **Mô phỏng giao dịch**.
- The Claude Code plugin sets up SePay MCP (`https://my.sepay.vn/mcp`): after installing the plugin, just sign in under `/mcp`, no Client ID to enter.
- Questions about language / framework now offer **Chọn giúp tôi** (pick for me).
- The skill knows its own version and how to update for each install method (plugin, `npx`, downloaded file).

### Changed

- Users writing from a chat app or an empty project who only describe the outcome (e.g. "make my site confirm bank transfers automatically") get plain-language answers from the start.
- The README states that the third-party `npx skills` tool (skills.sh) reports the repository name to skills.sh and how to opt out; the skill itself sends nothing.

### Fixed

- Scoop install of the `sepay` CLI: `scoop install sepay/sepay`, matching the CLI docs.

## [1.0.0] - 2026-11-06

First versioned release.

- Skill `sepay`: choosing an integration, webhooks, VietQR, virtual accounts (VA), payment gateway and IPN, SePay API, reconciliation and refunds, Bank Hub, e-invoices, Speaker devices, OAuth2, plugins, Test mode and go-live, the `sepay` CLI, SePay MCP.
- Downloadable `sepay.zip` and `sepay.md` for apps with a Skills feature and for chat apps.
- Packaged as a Claude plugin: `/plugin install sepay --marketplace sepayvn/sepay-skills`.

[1.0.1]: https://github.com/sepayvn/sepay-skills/releases/tag/v1.0.1
