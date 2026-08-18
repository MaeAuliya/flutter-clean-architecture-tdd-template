# Shared UI, Theme, and Responsive Layout

**Status: Mandatory theme consumption; preferred shared component layer.**

A design system is not a palette file. It is the chain from raw tokens, through semantic theme roles, into components that features actually use.

---

## Token hierarchy

```text
Primitive tokens       Semantic theme          Components             Features
brand blue       →     colorScheme.primary →  AppButton         →    submit action
neutral dark     →     onSurface           →  AppTextField      →    profile form
spacing 16       →     space.md             →  ScreenScaffold    →    all screens
```

Primitive tokens belong in theme construction. Widget code reads semantic roles.

**Mandatory.** Feature widgets must not reference raw color tokens or `Colors.*` for themed UI. Exceptions are intrinsic colors — a brand logo, a data-series palette, or a photographed color — and they should be named explicitly.

This rule addresses a proven failure mode: a mature reference implementation defines full light and dark `ColorScheme`s and its shared widgets consume them correctly, but feature widgets overwhelmingly read raw constants. The dark theme exists structurally yet cannot control those features.

---

## Theme definition

Build complete light and dark schemes:

```dart
ThemeData lightTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: /* token */,
    onPrimary: /* token */,
    surface: /* token */,
    onSurface: /* token */,
    error: /* token */,
  ),
  textTheme: appTextTheme,
  inputDecorationTheme: inputTheme,
  filledButtonTheme: buttonTheme,
);
```

Define component defaults in `ThemeData` before adding override parameters to every shared component. A component with fifteen optional color and size overrides is often a theme API rebuilt by hand.

---

## Shared component API

A shared component encodes stable accessibility, theme, and interaction policy while allowing meaningful variants:

```dart
enum AppButtonVariant { primary, secondary, destructive, text }

enum AppButtonSize { compact, regular }

final class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.regular,
    this.leading,
    this.isLoading = false,
  });
}
```

Prefer explicit variants over many independent booleans and style overrides. Invalid combinations should be hard to construct.

Shared components commonly include:

- Button/loading button
- Text field and PIN input
- App bar and screen scaffold
- Dialog/bottom sheet shell
- Loading, empty, and error states
- Avatar and skeleton primitives
- Stepper and status indicators

---

## Loading, empty, and error states

Create reusable state views with content slots or explicit variants:

```dart
sealed class ErrorPresentation { const ErrorPresentation(); }
final class StaticError extends ErrorPresentation {}
final class PullToRefreshError extends ErrorPresentation {}
final class RetryButtonError extends ErrorPresentation {}
```

**Legacy / anti-pattern.** Several independent flags such as `useButton`, `useRefresh`, and `useOutsideRefresh` produce ambiguous combinations and duplicated widget trees. Use one variant and extract the shared body.

Every error state states:

- What happened in user language
- Whether it is retryable
- One clear retry action when appropriate
- Accessible semantics

---

## Feature-local UI structure

- `screens/`: routed page shell and state wiring
- `views/`: large screen sections and state-specific bodies
- `widgets/`: small feature-local pieces
- `core/shared/`: only components with demonstrated cross-feature reuse

Do not move a component to shared on its first use. A stable API is easier to see after a second consumer exists.

---

## Responsive layout

The reference implementation uses scale factors derived from a design baseline:

```dart
double get widthScale => width / designWidth;
double get heightScale => height / designHeight;
double get responsiveScale => min(widthScale, heightScale);
```

This is useful for preserving proportions on nearby phone sizes, but blindly multiplying every dimension distorts tablets, landscape, split-screen, and accessibility.

**Preferred approach:**

- Use constraints and adaptive layout first (`LayoutBuilder`, flexible widgets)
- Use breakpoints for structural changes
- Use bounded scale factors for decorative dimensions
- Keep touch targets at platform minimums
- Let text scale according to accessibility settings

**Legacy / anti-pattern.** Clamping application-wide text scale to exactly 1.0 defeats a user accessibility setting. If a layout breaks at larger text, fix the layout rather than disabling the setting.

---

## Accessibility

- Text remains readable at increased system scale
- Touch targets meet platform minimums
- Color is not the only state indicator
- Contrast holds in light and dark modes
- Interactive images/icons have semantic labels
- Loading state is announced where appropriate
- Focus order matches visual order
- Motion respects reduced-motion preference where available

See [Performance and Accessibility](../quality/performance_and_accessibility.md).

---

## Common mistakes

- Raw tokens in feature widgets
- Complete dark theme but features hardcode light colors
- Shared component with dozens of nullable overrides
- One feature's bespoke component moved to core prematurely
- Skeleton layout does not match loaded layout, causing a large visual shift
- Text scale disabled globally
- Fixed height around multi-line localized text
- Error view duplicates four nearly identical branches

---

## Testing

- Golden or screenshot tests in light and dark modes
- Shared components at minimum/maximum supported text scale
- Compact and wide constraints
- Loading, disabled, error, and destructive variants
- Semantic labels and touch-target sizes
- Theme switch updates components without reconstructing app state

---

## Related documents

- [Forms and Validation](forms_and_validation.md)
- [Performance and Accessibility](../quality/performance_and_accessibility.md)
- [Adding Presentation](../workflows/adding_presentation.md)
- [Feature and Screen Specification](../templates/feature_and_screen_spec.md)
