---
name: qrCodeStandard
description: >-
  QR code scanner using device camera — frontend hook with jsQR. Read before
  scan-to-pay, ticket check-in, or invite-code scanning features.
---

# QR Code Scanner

Frontend-only — camera preview + jsQR decoding. No backend required unless
you validate scanned data server-side.

**Prerequisites:** [`../../frontendStandard/SKILL.md`](../../frontendStandard/SKILL.md),
[`extensionsStandard/cameraStandard/SKILL.md`](../cameraStandard/SKILL.md)

---

## Structure

```
frontend/
├── hooks/qrCode/useQrScanner.ts
├── components/qrCode/QrScannerPanel.tsx
└── lib/qrCode/parseQrPayload.ts
```

---

## Hook responsibilities

`useQrScanner` wraps camera access:

| State | Purpose |
|---|---|
| `qrResults` | Newest-first scan history |
| `isScanning` | Active decode loop |
| `isReady` | jsQR loaded + camera supported |
| `startScanning` / `stopScanning` | Lifecycle |
| `videoRef` / `canvasRef` | Attach to preview elements |

Config: `facingMode: 'environment'`, `scanInterval: 100`, `maxResults: 10`.

Load jsQR from CDN or bundle — default jsdelivr is fine for static export.

---

## UI rules

- Use shadcn `Button`, `Card` — no raw HTML controls.
- Show camera error messages (`permission`, `not-supported`, `not-found`).
- Disable buttons until camera is initialized.
- Preview needs explicit dimensions (`aspect-ratio` wrapper, min-height).
- Mobile: offer switch-camera; desktop: prefer `environment` only.
- Hide processing `canvas` (`display: none`).

---

## Backend validation (optional)

If QR encodes invite codes or payment refs, validate in `services/` — never
trust client-parsed data alone.

---

## Related

| Topic | Path |
|---|---|
| Camera | [`../cameraStandard/SKILL.md`](../cameraStandard/SKILL.md) |
| Frontend | [`../../frontendStandard/SKILL.md`](../../frontendStandard/SKILL.md) |
