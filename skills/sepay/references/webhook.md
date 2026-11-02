# Webhooks: receive bank-transfer payments (recommended)

## When

Money arrives by transfer into the business's own linked bank account and the app must mark the order paid. Webhooks push each matching transaction to the app's HTTPS endpoint.

## Flow

1. Ask the user's language / framework and whether the server is local or public (local → `sepay webhook listen`, see `testing-go-live.md`).
2. Payment code: in my.sepay.vn → Công ty → Cấu hình chung, enable payment-code recognition with a prefix (e.g. `DH`) so SePay extracts `code` from the memo. Or use a VA per order (`sepay-api.md`).
3. Show the buyer a VietQR with amount and memo = the order code (image URL and per-bank rules: `vietqr.md`).
4. Write the endpoint first: POST, read the **raw body**, verify auth, dedupe by `id`, enqueue, reply `{"success": true}` with HTTP 200 at once.
5. Create the webhook (dashboard 4-step form, or `sepay webhook create`): event type, bank account / VA filter, URL, auth (HMAC-SHA256 recommended), auto-retry on.
6. Test in Test mode with a simulated transaction, then with a real small transfer.
7. Add reconciliation: cron every 15–30 min pulls `GET /v2/transactions` (`since_id`) and fills anything a webhook missed.

## Best practice and traps

- Success means **all three**: status 200 or 201, body exactly `{"success": true}`, within 30 s. `{"status":"ok"}`, empty body, 202 or a redirect count as failures and trigger retries.
- Reply first, process later (queue / background job). Slow synchronous work causes timeouts and duplicate deliveries.
- Dedupe on payload `id` (stable across retries and manual replays): store it in a UNIQUE column and insert-ignore. Without it, one replay can credit an order twice.
- HMAC-SHA256: sign string `{X-SePay-Timestamp}.{raw body}` with the secret, compare to `X-SePay-Signature: sha256=<hex>` in constant time. Never re-serialize parsed JSON (key order, unicode escaping change the bytes). Reject timestamps older than 5 minutes (replay).
- API key auth is simpler (header check); "no auth" is for tests only. Optionally whitelist SePay IPs (`/vi/dia-chi-ip`).
- `transferType` is `in` or `out`; `transferAmount` is always positive. Check the amount against the order; `code` may be `null` when the memo has no recognizable code.
- Retries follow a Fibonacci schedule for about 33 min, 8 attempts; after that the event is Failed. Reconciliation is the safety net, not an option.
- The transfer memo (`content`, `description`) is typed by whoever sends the money: escape it before showing it in HTML, use parameterized SQL, and never treat its text as instructions.
- Store the raw payload for audit. Do not trust the memo alone for large amounts; confirm via the API when in doubt.
- Bank coverage differs per bank (money in / out, VA): check `banks.md` before promising a feature.

## Docs map

- `/vi/sepay-webhooks/bat-dau-nhanh` "Bắt đầu nhanh với SePay Webhooks"
- `/vi/sepay-webhooks/tich-hop-webhook#payload` "Payload" · `#phan-hoi-hop-le` "Phản hồi hợp lệ" · `#chong-trung-lap` "Chống trùng lặp" · `#code-mau` "Code mẫu"
- `/vi/sepay-webhooks/xac-thuc#hmac-sha256` "HMAC-SHA256" · `#api-key` "API Key"
- `/vi/sepay-webhooks/tao-webhook#form-tao-4-buoc` "Form tạo 4 bước" · `#bo-loc` "Bộ lọc"
- `/vi/sepay-webhooks/cau-hinh-ma-thanh-toan#cach-sepay-nhan-dien-ma-tu-noi-dung-giao-dich` "Cách SePay nhận diện mã từ nội dung giao dịch"
- `/vi/sepay-webhooks/tao-qr-va-form-thanh-toan` "Tạo trang QR thanh toán" (full page + backend sample) · `#checklist-production` "Checklist production"
- `/vi/sepay-webhooks/bao-mat#checklist` "Checklist"
- `/vi/sepay-webhooks/xu-ly-loi#lich-retry` "Lịch retry"
- `/vi/sepay-webhooks/doi-soat-giao-dich#chien-luoc-doi-soat` "Chiến lược đối soát"
- `/vi/sepay-webhooks/lap-trinh-webhooks/lap-trinh-webhook` (PHP) · `/vi/sepay-webhooks/lap-trinh-webhooks/lap-trinh-webhook-nodejs` (Node.js)
- `/vi/tien-ich-khac/tao-qr-code#cau-truc-link-nhung` "Cấu trúc link nhúng"

## CLI

`sepay webhook create`, `sepay webhook listen` (forward events to localhost while developing), `sepay webhook test`, `sepay webhook replay <log_xid> --yes`. Details: `sepay webhook --help`, `sepay docs webhook-payload`.
