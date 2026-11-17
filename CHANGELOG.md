# Nhật ký thay đổi

Tiếng Việt | [English](#changelog)

Phiên bản theo [semver](https://semver.org/lang/vi/). Số phiên bản nằm ở `.claude-plugin/plugin.json` và `metadata.version` trong `skills/sepay/SKILL.md`. Mỗi bản có tag `v<phiên bản>` trên trang [Releases](https://github.com/sepayvn/sepay-skills/releases), kèm `sepay.zip`, `sepay.md`, `sepay-claude-plugin.zip` (từ 1.0.2) và `SHA256SUMS`.

## [1.0.3] - 2026-11-17

### Sửa

- Cài bằng `npx skills add https://github.com/sepayvn/sepay-skills --skill sepay` chạy được trở lại. Ở bản 1.0.2, lệnh này báo lỗi đọc `SKILL.md` và không tìm thấy skill `sepay`.

## [1.0.2] - 2026-11-16

### Thêm

- Hỏi về dữ liệu SePay của chính bạn qua SePay MCP hoặc `sepay` CLI (`references/mcp.md`): AI chọn đúng công cụ cho từng câu hỏi, đọc hết mọi trang, không đoán phần bị ẩn, không tìm thấy thì nói không thấy. Câu trả lời là số liệu, trạng thái và bước làm tiếp, gọi tên như trên my.sepay.vn (tài khoản theo ngân hàng và 4 số cuối), không đọc mã kỹ thuật, không đưa code trừ khi bạn hỏi cách làm. Chưa kết nối SePay MCP hay đăng nhập CLI thì AI gợi ý cách kết nối, không đưa số.
- Doanh thu: ba cách tính (tất cả tiền vào, qua VA, có mã thanh toán; mặc định là có mã thanh toán và luôn nói rõ cách đang dùng), tiền qua cổng thanh toán và thẻ, chuyển quỹ nội bộ, hoàn tiền, theo điểm bán (VA) và theo ca. Báo cáo cho doanh thu gộp, hoàn tiền và thực thu; so kỳ (kỳ chưa hết thì so cùng số ngày); giải thích chênh lệch giữa 2 kỳ, giữa các cách tính và với sao kê ngân hàng.
- Tra soát giao dịch khi khách bảo "đã chuyển rồi": tìm theo mã đơn, mã thanh toán, tên trong nội dung chuyển khoản, số tiền gần đúng và giờ. Nhiều khoản cùng khớp thì liệt kê đủ và hỏi thêm; không thấy thì nói không thấy, không đưa giao dịch khác.
- Chốt ca theo một hoặc mọi điểm bán, hoặc theo tài khoản ngân hàng. Gọi điểm bán bằng tên ngắn, số hay một phần tên ("Điểm bán 1", "quầy 2", "Quận 1") thì AI hiểu là đúng một điểm bán và chỉ trả số của điểm bán đó.
- Đối soát tiền với hóa đơn điện tử: tổng hóa đơn khi có hóa đơn điều chỉnh, thay thế (không cộng trùng); ghép khoản đã thu với hóa đơn theo mã thanh toán; các ca khó (một hóa đơn trả nhiều lần, xuất trước thu sau, tiền vào không mã, hoàn tiền sau khi xuất); trạng thái hóa đơn chưa phát hành và lượt xuất còn lại.
- Câu hỏi kế toán (`references/accounting.md`): số liệu gửi kế toán, thuế GTGT của hóa đơn đã xuất, hoàn tiền chưa điều chỉnh, tiền và đơn của cổng thanh toán theo kỳ. AI không tư vấn thuế. Việc AI chưa làm được (xuất, thay thế, điều chỉnh hóa đơn, hủy đơn cổng) thì AI nói rõ và chỉ đúng trang trên my.sepay.vn.
- Đổi webhook hoặc mã thanh toán trên production theo 6 bước: ghi lại cấu hình cũ, chạy thử bằng `--dry-run`, bạn tự chạy lệnh đổi, kiểm bằng giao dịch thật đầu tiên, không đạt thì có sẵn lệnh quay lại.
- File tải về mới `sepay-claude-plugin.zip`, chỉ dùng cho Claude: plugin gồm cả skill `sepay` lẫn connector SePay MCP (đăng nhập bằng client của Claude), để tải lên mục Plugin của Claude trên web và Claude Desktop. Claude Code cài plugin như cũ bằng `/plugin install`.

### Thay đổi

- Lệnh ghi production của `sepay` CLI luôn do bạn tự chạy trong terminal của mình: AI chạy thử bằng `--dry-run` rồi đưa đúng lệnh, không kèm `--yes`. AI không tự chạy, kể cả khi bạn đã đồng ý trong chat. Token SePay luôn do bạn tự lấy và giữ kín.
- README có thêm phần hỏi về dữ liệu SePay của bạn: báo cáo doanh thu, tra soát và chốt ca, đối soát hóa đơn, câu hỏi kế toán, kèm câu hỏi ví dụ; hướng dẫn kết nối SePay MCP theo menu mới my.sepay.vn → AI Agent → Tạo kết nối.
- Gửi lại webhook bị lỗi qua SePay MCP theo 3 phần: xin duyệt (link duyệt 5 phút, mở bằng đúng tài khoản và công ty), chạy sau khi bạn duyệt (trong 10 phút), và theo dõi (lịch sử gửi webhook, AI Agent → Nhật ký hoạt động). AI giải thích đủ mọi kết quả, kể cả khi thiếu quyền, công ty chưa bật tính năng, lần gửi bị bộ lọc bỏ qua hoặc mã duyệt đã dùng.
- AI nhận ra tài khoản ngân hàng theo mã của tài khoản, không theo số tài khoản, nên không gán nhầm ngân hàng khi một số tài khoản kết nối ở hai ngân hàng.

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

[1.0.3]: https://github.com/sepayvn/sepay-skills/releases/tag/v1.0.3
[1.0.2]: https://github.com/sepayvn/sepay-skills/releases/tag/v1.0.2
[1.0.1]: https://github.com/sepayvn/sepay-skills/releases/tag/v1.0.1

---

# Changelog

[Tiếng Việt](#nhật-ký-thay-đổi) | English

Versions follow [semver](https://semver.org). The version lives in `.claude-plugin/plugin.json` and in `metadata.version` of `skills/sepay/SKILL.md`. Each release is tagged `v<version>` on the [Releases](https://github.com/sepayvn/sepay-skills/releases) page and ships `sepay.zip`, `sepay.md`, `sepay-claude-plugin.zip` (since 1.0.2) and `SHA256SUMS`.

## [1.0.3] - 2026-11-17

### Fixed

- Installing with `npx skills add https://github.com/sepayvn/sepay-skills --skill sepay` works again. In 1.0.2 the command failed to read `SKILL.md` and found no `sepay` skill.

## [1.0.2] - 2026-11-16

### Added

- Questions on your own SePay data through SePay MCP or the `sepay` CLI (`references/mcp.md`): the AI picks the right tool for each question, reads every page, never guesses hidden fields, and says "not found" when nothing matches. Answers are figures, statuses and next steps, named as on my.sepay.vn (accounts by bank and last 4 digits), with no technical codes and no integration code unless you ask how. Without SePay MCP or a CLI login, the AI suggests how to connect and gives no figures.
- Revenue: three methods (all money in, via VA, with payment code; the default is with payment code, always named in the answer), gateway and card payments, internal transfers, refunds, per point of sale (VA) and per shift. Reports give gross, refunds and net; compare periods (an unfinished period against the same number of days); and explain differences between periods, between methods and against a bank statement.
- Payment lookup when a customer says "I already paid": by order code, payment code, name in the transfer memo, near amount and time. Several matches are all listed with a follow-up question; no match means "not found", never another transaction.
- Shift close-out per point of sale, for every point of sale or per bank account. A point of sale named by a short name, number or part of its name ("Điểm bán 1", "quầy 2", "Quận 1") is that one point of sale, and the answer covers it only.
- Reconciling money with e-invoices: invoice totals with adjusting and replacing invoices (no double counting), matching payments to invoices by payment code, hard cases (one invoice paid in several transfers, issued before paid, transfers without a code, refunds after issuing), unissued invoice statuses and the issuing quota left.
- Accounting questions (`references/accounting.md`): figures for the accountant, VAT of issued invoices, refunds not yet adjusted, gateway money and orders per period. No tax advice. What the AI cannot do yet (issuing, replacing or adjusting invoices, cancelling gateway orders) is said plainly, with the right page on my.sepay.vn.
- Changing a webhook or payment code on production in 6 steps: record the old settings, dry-run with `--dry-run`, you run the change yourself, check with the first real transaction, and a ready command to roll back if it fails.
- New download `sepay-claude-plugin.zip`, for Claude only: the plugin with both the `sepay` skill and the SePay MCP connector (signing in with Claude's client), to upload under Plugins in Claude on the web and Claude Desktop. Claude Code installs the plugin with `/plugin install` as before.

### Changed

- Production write commands of the `sepay` CLI are always run by you in your own terminal: the AI dry-runs them with `--dry-run`, then gives the exact command, without `--yes`. The AI never runs them, even after you agree in chat. You always fetch your SePay token yourself and keep it private.
- The README gains a section on questions about your own SePay data: revenue reports, payment lookup and shift close-out, invoice reconciliation, accounting questions, with example questions; connecting SePay MCP follows the new menu my.sepay.vn → AI Agent → Tạo kết nối.
- Re-sending a failed webhook through SePay MCP in three parts: the approval request (a 5-minute link, opened with the same account and company), the send after you approve (within 10 minutes), and tracking (webhook delivery history, AI Agent → Nhật ký hoạt động). The AI explains every result, including a missing permission, the feature not turned on for the company, a delivery skipped by the webhook's filter and an approval already used.
- The AI identifies bank accounts by their id, not by account number, so an account number connected at two banks is never matched to the wrong bank.

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

[1.0.3]: https://github.com/sepayvn/sepay-skills/releases/tag/v1.0.3
[1.0.2]: https://github.com/sepayvn/sepay-skills/releases/tag/v1.0.2
[1.0.1]: https://github.com/sepayvn/sepay-skills/releases/tag/v1.0.1
