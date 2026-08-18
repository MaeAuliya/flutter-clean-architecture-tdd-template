# Location, Maps, Media, and Files

**Status: Optional integration patterns.**

These capabilities cross Flutter, native platform lifecycles, permissions, filesystem rules, and remote upload. Isolate each behind a shared capability module so features consume a stable domain API rather than plugin types.

---

## Location gateway

```dart
abstract interface class LocationGateway {
  Future<Result<LocationPoint>> current({required LocationAccuracy accuracy});
  Stream<LocationPoint> watch({required LocationPolicy policy});
  Future<bool> isServiceEnabled();
}
```

Domain types use neutral latitude/longitude/value objects, not plugin position types.

Policy includes:

- Required accuracy
- Timeout
- Maximum acceptable age
- Whether last-known location is acceptable
- Update interval/distance for a stream

**Mandatory.** A location request has a timeout and a cancellation/lifecycle owner. High-accuracy continuous tracking consumes substantial battery.

---

## Map presentation

Initialize the map SDK once with build-time configuration. Map state belongs in a route-scoped controller:

- Camera position
- Selected marker/item
- Markers and annotations
- Loading/error state
- User-location availability

Do not rebuild the map widget for every unrelated state change. Use selectors and update only annotations/camera when necessary.

Keep map SDK types in the map adapter/presentation edge. Domain location entities should remain SDK-neutral.

---

## External map applications

Hide URL-launch behavior behind a gateway:

```dart
abstract interface class MapLauncher {
  Future<Result<void>> openDirections(LocationPoint destination);
}
```

Validate that the target URL can be launched, encode coordinates/labels, and return a typed failure. Do not assemble custom URI strings in feature widgets.

---

## Media acquisition pipeline

```text
Feature
  → media use case
    → permission capability
    → camera/gallery source
    → local processing (orientation, size, compression)
    → upload use case
      → presigned URL or multipart data source
    → domain UploadResult
```

Separate capture from upload. This lets the UI preview/retry, supports alternative sources, and makes upload independently testable.

A shared media module may offer:

```dart
Future<Result<CapturedMedia>> capture(MediaRequest request);
Future<Result<UploadedMedia>> upload(CapturedMedia media);
```

---

## Camera lifecycle

- Initialize asynchronously and expose loading/error states
- Dispose controller on route exit
- Pause/release as platform lifecycle requires
- Guard capture against double tap
- Handle camera unavailable and permission changes
- Correct EXIF orientation before preview/upload
- Never retain unneeded sensitive images in temporary storage

A camera controller is a presentation/platform resource, not a domain entity.

---

## Image processing

Bound uploads deliberately:

- Maximum dimensions
- Encoding format
- Quality/compression target
- Maximum byte size after encoding
- Orientation and metadata policy

Strip unnecessary metadata when it may contain location or device information. Preserve only what the receiving contract requires.

Do CPU-heavy processing off the UI isolate when it exceeds a frame budget.

---

## Upload strategies

| Strategy | Use when | Notes |
|---|---|---|
| Multipart through API | Small files, simple backend | Must support auth replay if token expires |
| Presigned object-storage URL | Large/direct uploads | Separate authorization request from upload; URL has expiry |
| Resumable/chunked | Very large files or unreliable networks | More state and backend support |

Show upload progress only when meaningful. Support cancellation where the client/package allows it.

Multipart requests need replay-safe body reconstruction when authentication may refresh mid-request. See [Networking](networking.md).

---

## File handling

- Validate extension, MIME type, and actual content where risk requires it
- Never trust a user-selected filename as a path
- Use application support/documents directory for durable files
- Use temporary/cache directory for disposable files
- Open files through a gateway and handle "no supporting app"
- Clean temporary files on completion/cancellation according to policy
- Do not assume file paths remain valid after process restart unless copied to durable storage

---

## Privacy

Location and media are sensitive personal data.

- Request the minimum capability at the moment of use
- Explain user benefit
- Do not log coordinates, image paths, document content, or upload URLs
- Retain only as long as required
- Document whether data is uploaded and when
- Respect permission revocation mid-flow

---

## Testing

- Permission denied/permanently denied
- Service/camera unavailable
- Location timeout and stale last-known point
- Map renders empty, loading, error, and selected states
- Capture cancellation
- Oversized image is resized/compressed under limit
- Upload progress, cancellation, transient retry, auth replay
- Presigned URL expired
- Temporary file cleanup
- Unsupported file type and no opener available

---

## Related documents

- [Permissions and Device Capabilities](permissions_and_device.md)
- [Networking](networking.md)
- [Storage](storage.md)
- [Adding an Integration](../workflows/adding_integration.md)
