---
name: objectStorageStandard
description: >-
  Off-chain file storage with on-chain Blob references — galleries, documents,
  media beyond IC message limits. Backend cert mixin + frontend upload helper.
  Read before any file upload feature.
---

# Object Storage

File bytes live off-chain. The canister stores `ExternalBlob` references and
metadata. Frontend uploads via the storage gateway; backend never holds raw
file bytes in stable state.

**Prerequisites:**
[`../../integrationStandard/SKILL.md`](../../integrationStandard/SKILL.md),
[`../../frontendStandard/SKILL.md`](../../frontendStandard/SKILL.md),
[`../../layeringStandard/SKILL.md`](../../layeringStandard/SKILL.md)

---

## Required setup (all four)

Skipping any step causes `403 Forbidden: Invalid payload` on upload.

| Step | Action |
|---|---|
| 1 | `falcon add pkg objectStorage` — backend mops dependency |
| 2 | `include ObjectStorageMixin()` in `main.mo` from hub package |
| 3 | Every file field uses `ExternalBlob` — never `Text` |
| 4 | Frontend npm helper from hub — `ExternalBlob.fromBytes(...)` at upload |

Backend-only or frontend-only install → silent 403 at upload.

---

## Type rule

Any field for a file, image, photo, document, or media:

```motoko
import Storage "mo:pkg/objectStorage/Storage";

type FileRecord = {
  id : Text;
  blob : Storage.ExternalBlob;
  filename : Text;
  mimeType : Text;
  owner : Principal;
  createdAt : Int;
};
```

Wrong — breaks upload/download proxy:

```motoko
blobId : Text
imageUrl : Text
fileRef : Text
```

Method parameters accepting uploads use `ExternalBlob`, not `Text`.

Only import `ExternalBlob` from the storage pkg — other `Storage.mo` internals
are for the mixin, not direct calls.

---

## Backend (`main.mo`)

Mixin goes in `main.mo` only — not a custom mixin file:

```motoko
import ObjectStorageMixin "mo:pkg/objectStorage/Mixin";
import Storage "mo:pkg/objectStorage/Storage";

persistent actor App {
  include ObjectStorageMixin();

  let files = FileStorage.createFileMap();
  transient let fileService = FileService.create(files);
  include FileApi(fileService, mwConfig);
};
```

### Never hand-write platform methods

Do not implement `_immutableObjectStorageCreateCertificate` or any
`_immutableObjectStorage*` method yourself. Wrong return type → 403.

Correct signature from hub mixin:

```motoko
_immutableObjectStorageCreateCertificate : (blobHash : Text) -> async {
  method : Text;
  blob_hash : Text;
};
```

Wrong return types (`Blob`, `()`, `Text`) fail gateway validation.

---

## IcFalcon layers

```bash
falcon m:f File
```

| Layer | Role |
|---|---|
| `storage/FileStorage.mo` | Map of `FileRecord` |
| `repositories/FileRepository.mo` | CRUD |
| `services/FileService.mo` | Save ref after upload, list, delete, ownership |
| `validators/FileValidator.mo` | Filename, mimeType |
| `api/v1/File.mo` | `uploadFile`, `listFiles`, `deleteFile` |

`uploadFile` accepts `ExternalBlob` + metadata — store ref after gateway upload
completes on the frontend.

---

## Frontend

Install hub frontend helper (path from `falcon add pkg objectStorage` docs).

```typescript
import { ExternalBlob } from "@/lib/objectStorage/externalBlob"
```

### Upload

Pass `file.type` and `file.name` so gateway stores `Content-Type` and
`Content-Disposition`. Also save `filename` on the backend for lists/UI.

```typescript
const handleUpload = async (file: File) => {
  const bytes = new Uint8Array(await file.arrayBuffer())
  const blob = ExternalBlob.fromBytes(bytes, file.type, file.name)
    .withUploadProgress(setProgress)

  const result = await uploadFile(identity, file.name, file.type, blob)
  if (!result.ok) throw new Error(result.error)
}
```

Service in `services/file/file.ts` — never call actor from component directly.

### Display

Use `getDirectURL()` for inline image/video. URL is opaque — **no extension**.

```tsx
<img src={record.blob.getDirectURL()} alt={record.filename} />
```

Detect type from `filename` or `mimeType` — never from URL:

```typescript
const isImage = (mime?: string) => mime?.startsWith("image/")
const isImageByName = (name: string) =>
  /\.(jpg|jpeg|png|gif|webp|svg|bmp|ico)$/i.test(name)
```

### Download

`getDirectURL()` — stream/display. `getBytes()` — save-as with filename:

```typescript
const bytes = await record.blob.getBytes()
const url = URL.createObjectURL(new Blob([bytes]))
const a = document.createElement("a")
a.href = url
a.download = record.filename
a.click()
URL.revokeObjectURL(url)
```

---

## Summary

| Use case | Method |
|---|---|
| Display image/video | `blob.getDirectURL()` |
| Download with filename | `blob.getBytes()` + anchor |
| Upload | `ExternalBlob.fromBytes(bytes, type, name)` |
| Detect type | `filename` or `mimeType` — not URL |

---

## Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `403 Invalid payload` on PUT | Missing or wrong cert method | `falcon add pkg objectStorage`, `include ObjectStorageMixin()` in `main.mo`, redeploy |
| `403` all files | Frontend pkg without backend pkg | Install both via hub |
| Method exists, still 403 | Hand-written stub with wrong return type | Remove stub, use hub mixin |
| Upload works, list empty | Saved `Text` instead of `ExternalBlob` | Fix types in `types.mo` |

---

## Verify

```bash
falcon add pkg objectStorage
falcon b:test --local
falcon b:deploy --local
falcon f:build
```

Check `backend/mops.toml` lists the object storage dependency after add.

---

## Related

| Topic | Path |
|---|---|
| Camera capture | [`../cameraStandard/SKILL.md`](../cameraStandard/SKILL.md) |
| Frontend | [`../../frontendStandard/SKILL.md`](../../frontendStandard/SKILL.md) |
| Integration | [`../../integrationStandard/SKILL.md`](../../integrationStandard/SKILL.md) |
