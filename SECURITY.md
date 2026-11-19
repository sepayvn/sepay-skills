# Chính sách bảo mật

Tiếng Việt | [English](#security-policy)

## Báo lỗi bảo mật

Gửi email tới support@sepay.vn, tiêu đề `Security: sepay skill`. Không mở issue công khai.

## Phiên bản được hỗ trợ

Phiên bản theo semver, ghi ở `.claude-plugin/plugin.json` và `metadata.version` trong `skills/sepay/SKILL.md`; thay đổi từng bản ở [CHANGELOG.md](CHANGELOG.md). Chỉ bản mới nhất được sửa lỗi bảo mật. Cập nhật theo cách đã cài: plugin Claude Code gõ `/plugin update sepay@sepay` trong Claude Code hoặc chạy `claude plugin update sepay` ở terminal, `npx skills update sepay`, hoặc tải lại `sepay.zip` / `sepay.md` từ trang Releases.

## Dữ liệu từ giao dịch

Khi bạn hỏi về dữ liệu của chính mình qua SePay MCP hoặc `sepay` CLI, AI đọc giao dịch, lịch sử gửi webhook và hóa đơn. Chữ trong đó đến từ ba nguồn:

- Ngân hàng, trên production, theo quy định của Ngân hàng Nhà nước: tên người chuyển là tên chủ tài khoản do ngân hàng người chuyển cung cấp, người chuyển không tự gõ; nội dung chuyển khoản là chữ ngắn, không có ký tự đặc biệt, nên không chứa được markup, code, đường link hay cú pháp lệnh.
- Chính doanh nghiệp: tên gợi nhớ tài khoản, tên webhook, dữ liệu hóa đơn và đơn cổng thanh toán.
- Sandbox: chữ do bạn hoặc AI mô phỏng.

Skill dặn AI coi mọi chữ đó là dữ liệu, không phải chỉ dẫn: chỉ đọc lại hoặc dùng để so khớp, gặp câu giống lệnh thì bỏ qua và báo bạn. Đọc dữ liệu không bao giờ dẫn tới thao tác ghi, chạy lệnh hay gọi mạng; thao tác ghi duy nhất (gửi lại webhook) chỉ chạy khi bạn yêu cầu và đồng ý. Rủi ro còn lại: một người chuyển tiền vẫn có thể gõ một câu chữ thường trong nội dung chuyển khoản.

---

# Security policy

[Tiếng Việt](#chính-sách-bảo-mật) | English

## Reporting a vulnerability

Email support@sepay.vn with the subject `Security: sepay skill`. Do not open a public issue.

## Supported versions

Versions follow semver and live in `.claude-plugin/plugin.json` and `metadata.version` of `skills/sepay/SKILL.md`; each release's changes are in [CHANGELOG.md](CHANGELOG.md). Only the latest version receives security fixes. Update the way you installed: Claude Code plugin `/plugin update sepay@sepay` in Claude Code or `claude plugin update sepay` in a terminal, `npx skills update sepay`, or download `sepay.zip` / `sepay.md` again from Releases.

## Data from transactions

When you ask about your own data through SePay MCP or the `sepay` CLI, the AI reads transactions, webhook delivery history and invoices. Their text comes from three sources:

- The banks, on production, under State Bank of Vietnam rules: the sender name is the account holder's name given by the sender's bank, not typed by the sender; the transfer memo is short text with no special characters, so it cannot carry markup, code, links or command syntax.
- The business itself: account labels, webhook names, invoice and payment-gateway order data.
- Sandbox: text you or the AI simulated.

The skill tells the AI to treat all of it as data, never instructions: it is only read back or matched, and text that reads like a command is ignored and reported to you. Reading data never leads to a write, a command or a network call; the only write (re-sending a webhook) runs only when you ask and approve it. Remaining risk: a sender can still type a sentence of plain words in the memo.
