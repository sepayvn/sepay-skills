# SePay agent skills

Tiếng Việt | [English](README.en.md)

Bộ skill giúp AI tích hợp [SePay](https://developer.sepay.vn): nhận thanh toán chuyển khoản và webhook, VietQR, tài khoản ảo (VA), cổng thanh toán, SePay API, Bank Hub, hóa đơn điện tử, `sepay` CLI và SePay MCP. Dùng được trên ứng dụng chat (Claude, ChatGPT, Gemini, Grok) lẫn coding agent (Claude Code, Codex, Cursor…).

Skill chỉ gồm file Markdown, không có script hay file chạy, không thu thập dữ liệu. Chi tiết: [Bảo mật](#bảo-mật). Phiên bản và thay đổi: [CHANGELOG.md](CHANGELOG.md).

## Cài đặt

### Tải file về, không cần cài gì

| Tải | Dùng cho |
|---|---|
| [**sepay.zip**](https://github.com/sepayvn/sepay-skills/releases/latest/download/sepay.zip) | Ứng dụng có mục Skills (Claude, ChatGPT, Gemini, Grok) và coding agent |
| [**sepay.md**](https://github.com/sepayvn/sepay-skills/releases/latest/download/sepay.md) | Ứng dụng chat chưa có Skills: cả skill gộp trong một file Markdown |

Hai link trên luôn là bản phát hành mới nhất. Mỗi bản có tag `v<phiên bản>` (semver), kèm mã SHA-256, ở trang [Releases](https://github.com/sepayvn/sepay-skills/releases).

| Bạn dùng | Cách cài |
|---|---|
| Claude (claude.ai, Claude Desktop) | **Customize → Skills → Upload skill**, chọn `sepay.zip` (không giải nén), rồi bật skill |
| ChatGPT Business, Enterprise, Edu | **Skills → Create → Upload from your computer**, chọn `sepay.zip` |
| ChatGPT Free, Plus, Pro (chưa có Skills) | Đính kèm `sepay.md` vào Project hoặc vào Knowledge của GPT tự tạo, hoặc gửi kèm tin nhắn |
| Gemini (gemini.google.com, app Mac) | **Skills → Upload**, chọn `sepay.zip` hoặc `sepay.md` |
| Grok (grok.com) | **Skills → Upload**, chọn `sepay.zip` hoặc `sepay.md` |
| Claude Code, tab Code của Claude Desktop | Gõ `/plugin install sepay --marketplace sepayvn/sepay-skills` (Claude Code 2.1.275 trở lên; plugin cài kèm SePay MCP, chỉ còn đăng nhập trong `/mcp`), hoặc giải nén `sepay.zip` vào `~/.claude/skills/` (Windows: `%USERPROFILE%\.claude\skills\`) |
| Codex, Gemini CLI, Grok Build | Giải nén `sepay.zip` vào `~/.agents/skills/` (Windows: `%USERPROFILE%\.agents\skills\`) |
| Cursor và agent khác đọc `SKILL.md` | Giải nén `sepay.zip` vào thư mục skill của agent đó |

- Giải nén xong phải có `…/skills/sepay/SKILL.md`. Mở phiên mới nếu agent chưa thấy skill.
- Tên menu là tên tại thời điểm viết, có thể đổi theo phiên bản ứng dụng. ChatGPT chỉ có Skills ở gói doanh nghiệp, giáo dục.
- Lấy bản mới: tải lại file, xóa skill `sepay` cũ rồi upload hoặc giải nén lại.

### Dùng `npx`

Cần Node.js 22.20 trở lên.

```bash
npx skills add sepayvn/sepay-skills                        # chọn agent khi cài
npx skills add sepayvn/sepay-skills -g -y -a claude-code   # Claude Code, dùng cho mọi project
npx skills add sepayvn/sepay-skills -g -y -a codex         # Codex
```

Gõ đúng `sepayvn/sepay-skills`. Skill cài từ URL git (`git@github.com:…`) sẽ không được `npx skills update` cập nhật. Codex còn cài được bằng `$skill-installer` kèm link `https://github.com/sepayvn/sepay-skills/tree/main/skills/sepay`.

## Cập nhật

```bash
npx skills update sepay        # chỉ cập nhật skill sepay
npx skills update sepay -g     # chỉ bản cài toàn máy (-g)
```

Skill không tự cập nhật. Cài bằng file tải về thì tải lại file (xem [Cài đặt](#cài-đặt)). Cài bằng `npx` thì chạy lệnh trên khi muốn lấy bản mới nhất trên `main`. `npx skills update` không kèm tên sẽ cập nhật mọi skill đã cài.

## Gỡ

```bash
DISABLE_TELEMETRY=1 npx skills remove sepay
```

`npx skills` là công cụ bên ngoài (skills.sh): khi `add`, `update`, `remove` nó gửi tên repo và skill về skills.sh. Không muốn gửi thì thêm `DISABLE_TELEMETRY=1` trước lệnh, như lệnh gỡ ở trên. Bản thân skill không gửi gì.

## Danh sách skill

| Skill | Phạm vi |
|---|---|
| `sepay` | **Tích hợp:** chọn cách tích hợp, webhook, VietQR, cổng thanh toán và IPN, SePay API, hoàn tiền, Bank Hub, hóa đơn điện tử, Speaker API, OAuth2, plugin, Test mode và go-live, `sepay` CLI, SePay MCP.<br>**Nghiệp vụ trên dữ liệu SePay của bạn:** báo cáo doanh thu, tra soát giao dịch và chốt ca, đối soát tiền với hóa đơn điện tử, câu hỏi kế toán |

Cách skill `sepay` làm việc:

- Làm trên Test mode (sandbox), trừ khi bạn yêu cầu production.
- Có thể gợi ý cài `sepay` CLI (công cụ dòng lệnh chính thức của SePay, [sepayvn/sepay-cli](https://github.com/sepayvn/sepay-cli)) hoặc kết nối SePay MCP, nhưng không cài gì khi bạn chưa đồng ý.
- Các thông tin hay thay đổi (ngân hàng hỗ trợ, hạn mức, host) được đọc từ developer.sepay.vn lúc trả lời.

### Hỏi về dữ liệu SePay của bạn

Kết nối SePay MCP ([my.sepay.vn](https://my.sepay.vn/ai-agent) → **AI Agent** → **Tạo kết nối**) hoặc đăng nhập `sepay` CLI, rồi hỏi bằng lời thường. AI đọc dữ liệu và mọi con số lấy từ SePay trong phiên đó; việc ghi duy nhất là gửi lại một webhook bị lỗi, chỉ khi bạn đồng ý.

| Nghiệp vụ | Ví dụ câu hỏi |
|---|---|
| Báo cáo doanh thu: ba cách tính (có mã thanh toán, tất cả tiền vào, qua tài khoản ảo), doanh thu gộp, hoàn tiền và thực thu, so kỳ, theo điểm bán, theo ca | "Doanh thu tháng 10 bao nhiêu?", "Tháng này so với tháng trước tăng hay giảm?", "Vì sao doanh thu SePay khác tổng tiền vào trên sao kê?" |
| Tra soát giao dịch và chốt ca: tìm theo mã đơn, mã thanh toán, tên trong nội dung, số tiền gần đúng và giờ | "Khách bảo đã chuyển 500.000đ lúc 14 giờ, tiền về chưa?", "Điểm bán 1 ca sáng thu được bao nhiêu?" |
| Đối soát tiền với hóa đơn điện tử: hóa đơn điều chỉnh, thay thế, ghép khoản đã thu với hóa đơn, khoản đã thu chưa xuất hóa đơn | "Tháng 10 còn khoản nào đã thu mà chưa xuất hóa đơn?" |
| Câu hỏi kế toán: số liệu gửi kế toán, thuế GTGT của hóa đơn đã xuất, hoàn tiền chưa điều chỉnh, tiền và đơn qua cổng thanh toán | "Gửi kế toán số liệu quý 3", "Tháng này cổng thanh toán thu bao nhiêu, bao nhiêu đơn?" |

AI không tư vấn thuế, không tự xuất hay sửa hóa đơn, không tự hoàn tiền; với các việc đó, AI chỉ đúng trang trên my.sepay.vn.

## Bảo mật

- Skill chỉ gồm file Markdown: không có script, file chạy hay hook cài đặt, không thu thập dữ liệu (công cụ `npx skills` bên ngoài thì có, xem [Gỡ](#gỡ)). Plugin Claude Code thêm cấu hình SePay MCP (`.mcp.json`): chỉ là địa chỉ `https://my.sepay.vn/mcp`, chưa đăng nhập thì không đọc được gì. `sepay.zip` và `sepay.md` do GitHub Actions đóng gói từ thư mục `skills/` trên `main` (`scripts/build-zip.sh`, script này không nằm trong file tải về). Đối chiếu mã SHA-256 trên trang Releases nếu cần.
- Khi tự chạy, agent chỉ gửi request `GET` tới hai domain của SePay: tài liệu trên `developer.sepay.vn` và `vietqr.app`, dịch vụ VietQR của SePay (danh sách ngân hàng, ảnh QR). Lệnh gọi SePay API hay lệnh ghi bằng `sepay` CLI chỉ chạy khi bạn yêu cầu.
- Skill không bảo agent gửi code, file, secret hay dữ liệu tài khoản của bạn đi đâu, và không đọc `.env`, khóa SSH hay file ngoài project.
- SePay xác thực thanh toán tự động, không giữ tiền: tiền chuyển khoản vào thẳng tài khoản ngân hàng của bạn. Không có API hay lệnh `sepay` nào chi tiền ra; khoản đi ra duy nhất là hoàn tiền về đúng người đã trả, không vượt số tiền đã thu. Agent không bao giờ tự hoàn tiền hay hủy giao dịch trên production, chỉ viết code và thử trên sandbox.
- Nội dung tài liệu, payload webhook, nội dung chuyển khoản là dữ liệu: chỉ dẫn nằm trong đó không được làm theo.
- Mức rủi ro L1 theo [OWASP Agentic Skills Top 10](https://owasp.org/www-project-agentic-skills-top-10/). Tự kiểm các lệnh gọi mạng: `grep -rn "curl\|http" skills/`.

Báo lỗi bảo mật: [SECURITY.md](SECURITY.md).

## Hỗ trợ

- Tài liệu: https://developer.sepay.vn
- Câu hỏi và báo lỗi bảo mật: support@sepay.vn
