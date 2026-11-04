# Testing (Test mode, sandbox) and going live

## Default: test first

Unless the user says production, build and test in **Test mode / sandbox**: base URLs, credentials and data are separate from live; only hosts and credentials change at go-live, the integration steps do not. Read the product's "sandbox" / "so sánh với Live" page to list the differences.

| Product | Sandbox |
|---|---|
| Webhooks, SePay API v2 | Test mode in my.sepay.vn (sidebar → Test mode), API `https://userapi-sandbox.sepay.vn/v2` with a Test mode token |
| Payment gateway | `https://pgapi-sandbox.sepay.vn`, checkout `https://pay-sandbox.sepay.vn`, sandbox merchant credentials |
| Bank Hub | its own sandbox base URL, credentials and test accounts |
| eInvoice | `https://einvoice-api-sandbox.sepay.vn`, sandbox token |

Confirm hosts on the product's sandbox page before hardcoding them.

## Test mode (webhooks, API v2)

1. Turn on Test mode (SuperAdmin / Admin by default; others need the "Cho phép truy cập Test mode" permission).
2. Create or copy a bank account, optionally a VA (official VA prefix `SBSEPAY`, or a content VA).
3. Configure payment-code recognition for Test mode (separate from live).
4. Create the webhook (same auth types and filters as live), or an API Access token for `userapi-sandbox`.
5. Send a transaction from **Mô phỏng giao dịch**; the payload matches live. Check the delivery in the webhook history.
6. Test mode has quotas per resource (accounts, VAs, webhooks, simulated transactions); see `/vi/tien-ich-khac/test-mode/han-muc`.

## Callbacks from SePay to your machine

Webhooks and IPNs are sent by SePay's servers. While the handler runs on the user's machine, use the `sepay` CLI first; it needs no tunnel and no public URL (`cli.md`). Not installed: suggest it once (`SKILL.md` › Tools worth suggesting), install only with the user's go-ahead:

1. **SePay Webhooks** (sandbox and production): `sepay webhook listen --forward localhost:3000/<path>` receives a copy of every delivery (same body and headers, so signature checks behave as in production) and forwards it to the local handler. `sepay webhook test` sends a sample delivery. Details: `sepay webhook listen --help`.
2. **Bank Hub IPN** (sandbox): `sepay bankhub ipn listen`.
3. **Only when the CLI cannot forward the callback** (payment gateway IPN) or the user cannot use the CLI: expose the port with a tunnel. Check what is installed (`command -v cloudflared`, `command -v ngrok`); offer to install one only with the user's go-ahead, then run e.g. `cloudflared tunnel --url http://localhost:3000` and use the HTTPS URL it prints.
4. A server with a public domain uses that URL directly (HTTPS recommended, HTTP accepted).
5. Never register `localhost`, `127.0.0.1`, `192.168.x`, `10.x` or other private addresses as the callback URL.

HTTP is accepted in Test mode and on live. An HTTPS URL needs a valid certificate on live (self-signed is rejected); Test mode also accepts self-signed.

## Go-live checklist

- Production base URL and production credentials (new token / merchant key / client secret), stored as secrets.
- Webhook / IPN URL: public; HTTPS with a valid certificate recommended (HTTP works, with payload and headers in clear text); auth on (HMAC-SHA256 or API key / secret key); optionally SePay IP allowlist (`/vi/dia-chi-ip`).
- Handler replies within the time limit; `success: true` only when that transfer paid an order, `false` for unmatched / under / duplicate payments (`webhook.md` § Response); idempotent; state changes are conditional transitions (`integration-design.md` § 3).
- Raw payload kept in a restricted table; logs mask account numbers and carry no memo, names or secrets (§ 6).
- An empty secret setting rejects every callback (§ 5).
- Reconciliation job running (`sepay-api.md`); failure alerts enabled (Telegram / email, `/vi/sepay-webhooks/giam-sat`).
- Payment-code / VA configuration recreated on live (Test mode settings do not carry over).
- Rate limits respected; secrets not in the repo or the frontend.
- One small real transaction end to end before announcing.

## Docs map

- `/vi/tien-ich-khac/test-mode#bat-test-mode` "Bật Test mode" · `#tai-nguyen-cau-hinh-trong-test-mode`
- `/vi/tien-ich-khac/test-mode/mo-phong-giao-dich#cac-truong-trong-form` · `#payload-webhook` "Payload webhook"
- `/vi/sepay-webhooks/test-mode/so-sanh-voi-live#khac-biet-giua-test-mode-va-live`
- `/vi/sepay-webhooks/test-mode/bat-dau-nhanh`
- `/vi/cong-thanh-toan/sandbox#chuyen-sang-production-khi-san-sang`
- `/vi/einvoice-api/v1/sandbox#chuyen-sang-production-khi-san-sang`
- `/vi/bankhub/thong-tin-sandbox#base-url-sandbox`
- `/vi/dia-chi-ip#danh-sach-dia-chi-ip`

## CLI

`sepay sandbox init`, `sepay sandbox simulate` (simulated transaction), `sepay sandbox reset --yes`, `sepay webhook listen`. `--env production` only when the user asks.
