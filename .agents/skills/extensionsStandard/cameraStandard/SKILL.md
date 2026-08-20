---
name: cameraStandard
description: >-
  Web camera access — photo capture, facing mode, error handling. Frontend hook
  only. Read before QR scanner or profile photo features.
---

# Camera

Frontend web camera via `getUserMedia`. Build a local hook — no external
platform package required.

**Prerequisites:** [`../../frontendStandard/SKILL.md`](../../frontendStandard/SKILL.md)

---

## Structure

```
frontend/hooks/camera/useCamera.ts
frontend/components/camera/CameraPanel.tsx
```

---

## Hook API

```typescript
export type CameraConfig = {
  facingMode?: "user" | "environment"
  width?: number
  height?: number
  quality?: number
  format?: "image/jpeg" | "image/png" | "image/webp"
}

export function useCamera(config?: CameraConfig) {
  // isActive, isSupported, error, isLoading
  // startCamera, stopCamera, capturePhoto, switchCamera, retry
  // videoRef, canvasRef
}
```

---

## UI rules

- Always show live preview when camera is open.
- Place capture button on the preview panel.
- Disable controls while `isLoading`.
- Preview: `width: 100%` + stable `aspect-ratio` — never collapse to zero height.
- `playsInline` + `muted` on `<video>`.
- Desktop: do not offer camera switch if only one device works.
- Display typed errors: `permission`, `not-supported`, `not-found`, `timeout`.

Use shadcn components for all controls.

---

## Upload flow

`capturePhoto()` returns `File | null` → pass to object storage upload service
if persisting — see [`../objectStorageStandard/SKILL.md`](../objectStorageStandard/SKILL.md).

---

## Related

| Topic | Path |
|---|---|
| QR scanner | [`../qrCodeStandard/SKILL.md`](../qrCodeStandard/SKILL.md) |
| Object storage | [`../objectStorageStandard/SKILL.md`](../objectStorageStandard/SKILL.md) |
