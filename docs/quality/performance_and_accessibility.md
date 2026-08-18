# Performance and Accessibility

**Status: Mandatory outcomes; implementation is context-dependent.**

Performance and accessibility are architecture concerns because late fixes often require changing state ownership, component APIs, and layout assumptions.

## Performance

### Measure first

Use profile/release mode and platform tooling. Debug-mode frame timing is not representative. Record a reproduction scenario before optimizing.

### Rebuild scope

- Split widgets at meaningful state boundaries
- Use selectors/build filters for small sub-state
- Keep immutable equality accurate
- Do not recreate streams/futures/controllers in `build`
- Do not rebuild map/camera/video surfaces for unrelated state
- Prefer `const` where it prevents actual reconstruction; do not chase it cosmetically

### Lists and media

- Use lazy builders for long lists
- Paginate large remote collections
- Give images bounded dimensions and cache policy
- Decode near display size where possible
- Move expensive image processing off the UI isolate
- Skeleton shape should match loaded content to reduce layout shift

### Startup

- Block only on prerequisites
- Use cached/default remote config before network refresh
- Defer optional SDK initialization
- Measure first meaningful paint and ready-to-interact separately

### Battery/network

- Bound high-accuracy location and sensor streams
- Debounce search and avoid duplicate pagination calls
- Cache according to freshness policy
- Do not poll where push/stream or lifecycle refresh suffices

## Accessibility

### Text scaling

**Mandatory.** Do not clamp system text scale to 1.0. Test supported scaling and make layouts reflow. Avoid fixed-height containers around text.

### Semantics and interaction

- Every icon-only action has a semantic label/tooltip
- Interactive controls meet platform touch-target minimums
- Focus order follows reading order
- Errors are associated with fields and announced
- Color is not the sole state cue
- Custom gestures have accessible alternatives

### Visual

- Check contrast in light and dark themes
- Text over images has a controlled contrast surface
- Disabled state remains legible
- Motion is non-essential and respects reduced-motion preferences where supported

### Localization readiness

Even without localization today:

- Do not size to English string length
- Avoid concatenating sentence fragments
- Support RTL layout through directional padding/alignment
- Keep user copy out of data/domain

## Verification matrix

```text
[ ] Profile-mode critical journey has no sustained jank
[ ] Long list loads incrementally and does not duplicate requests
[ ] Screen works at supported max text scale
[ ] Screen works at narrow width and landscape where supported
[ ] Light/dark contrast checked
[ ] Screen-reader labels on non-text controls
[ ] Keyboard/focus navigation checked where relevant
[ ] Permission/error/loading announcements make sense
```

## Related documents

- [Shared UI](../patterns/shared_ui.md)
- [Pagination and Caching](../patterns/pagination_and_caching.md)
- [Definition of Done](definition_of_done.md)
