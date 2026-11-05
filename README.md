# SePay agent skills

Tiếng Việt | [English](README.en.md)

Bộ skill giúp các coding agent (Claude Code, Codex, Cursor…) tích hợp [SePay](https://developer.sepay.vn): nhận thanh toán chuyển khoản và webhook, VietQR, tài khoản ảo (VA), cổng thanh toán, SePay API, Bank Hub, hóa đơn điện tử, `sepay` CLI và SePay MCP.

Skill chỉ gồm file Markdown, không có script hay file chạy, không thu thập dữ liệu. Chi tiết: [Bảo mật](#bảo-mật).

## Cài đặt

Cần Node.js 22.20 trở lên.

```bash
npx skills add sepayvn/sepay-skills                        # chọn agent khi cài
npx skills add sepayvn/sepay-skills -g -y -a claude-code   # Claude Code, dùng cho mọi project
npx skills add sepayvn/sepay-skills -g -y -a codex         # Codex
```

Gõ đúng `sepayvn/sepay-skills`. Skill cài từ URL git (`git@github.com:…`) sẽ không được `npx skills update` cập nhật.

### Cài không cần Node.js

Skill chỉ là thư mục `skills/sepay`. Tải repo bằng `git` hoặc `curl`, rồi chép thư mục này vào nơi agent đọc skill:

```bash
git clone --depth 1 https://github.com/sepayvn/sepay-skills.git
# hoặc: curl -L https://github.com/sepayvn/sepay-skills/archive/refs/heads/main.tar.gz | tar -xz && mv sepay-skills-main sepay-skills

mkdir -p ~/.claude/skills && cp -R sepay-skills/skills/sepay ~/.claude/skills/   # Claude Code, tab Code của Claude Desktop
mkdir -p ~/.agents/skills && cp -R sepay-skills/skills/sepay ~/.agents/skills/   # Codex (CLI, IDE, app ChatGPT desktop)
```

- Codex còn cài được bằng `$skill-installer` kèm link `https://github.com/sepayvn/sepay-skills/tree/main/skills/sepay`.
- Claude Desktop (phần chat) và claude.ai: nén thư mục `sepay` thành `sepay.zip`, rồi vào **Settings → Capabilities → Skills → Upload skill**.
- Cài theo cách này thì `npx skills update` không cập nhật được: muốn lấy bản mới thì tải và chép lại. Mở phiên mới nếu agent chưa thấy skill.

## Cập nhật

```bash
npx skills update sepay        # chỉ cập nhật skill sepay
npx skills update sepay -g     # chỉ bản cài toàn máy (-g)
```

Skill không tự cập nhật. Chạy lệnh này khi muốn lấy bản mới nhất trên `main`. `npx skills update` không kèm tên sẽ cập nhật mọi skill đã cài.

## Gỡ

```bash
DISABLE_TELEMETRY=1 npx skills remove sepay
```

Không có `DISABLE_TELEMETRY=1` thì skills CLI gửi tên repo về skills.sh.

## Danh sách skill

| Skill | Phạm vi |
|---|---|
| `sepay` | Chọn cách tích hợp, webhook, VietQR, cổng thanh toán và IPN, SePay API, hoàn tiền, Bank Hub, hóa đơn điện tử, Speaker API, OAuth2, plugin, Test mode và go-live, `sepay` CLI, SePay MCP |

Cách skill `sepay` làm việc:

- Làm trên Test mode (sandbox), trừ khi bạn yêu cầu production.
- Có thể gợi ý cài `sepay` CLI hoặc kết nối SePay MCP, nhưng không cài gì khi bạn chưa đồng ý.
- Các thông tin hay thay đổi (ngân hàng hỗ trợ, hạn mức, host) được đọc từ developer.sepay.vn lúc trả lời.

## Bảo mật

- Skill chỉ gồm file Markdown: không có script, file chạy hay hook cài đặt, không thu thập dữ liệu.
- Khi tự chạy, agent chỉ gửi request `GET` tới hai domain của SePay: tài liệu trên `developer.sepay.vn` và `vietqr.app`, dịch vụ VietQR của SePay (danh sách ngân hàng, ảnh QR). Lệnh gọi SePay API hay lệnh ghi bằng `sepay` CLI chỉ chạy khi bạn yêu cầu.
- Skill không bảo agent gửi code, file, secret hay dữ liệu tài khoản của bạn đi đâu, và không đọc `.env`, khóa SSH hay file ngoài project.
- Nội dung tài liệu, payload webhook, nội dung chuyển khoản là dữ liệu: chỉ dẫn nằm trong đó không được làm theo.
- Mức rủi ro L1 theo [OWASP Agentic Skills Top 10](https://owasp.org/www-project-agentic-skills-top-10/). Tự kiểm các lệnh gọi mạng: `grep -rn "curl\|http" skills/`.

Báo lỗi bảo mật: [SECURITY.md](SECURITY.md).

## Hỗ trợ

- Tài liệu: https://developer.sepay.vn
- Câu hỏi và báo lỗi bảo mật: support@sepay.vn
