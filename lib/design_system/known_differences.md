# Known renderer differences

Where the Material and Cupertino branches of a component differ on purpose.
Add one line for each new difference, and comment it in the component too.

- **AdaptiveScaffold**: Cupertino has no bottom slot, so `bottomBar` sits in a column below the body. The Material title follows platform alignment (centred on iOS, start-aligned elsewhere).
- **AdaptiveButton.secondary**: Material uses an outlined button; Cupertino uses its native tinted fill.
- **AdaptiveButton** (disabled): each package uses its own disabled colours (Material onSurface at 12%; Cupertino system fill).
- **AdaptiveTextField**: CupertinoTextField has no label or error slot, so the label is drawn above the field and the error below it. Material floats the label inside the outline.
- **AdaptiveListTile**: tappable Cupertino rows with no `trailing` show the iOS chevron.
- **showAdaptiveConfirmDialog**: iOS alerts can't be dismissed by tapping outside; Material dialogs can (the result is `false`).
- **AdaptiveLoadingIndicator**: Material circular indicator vs. iOS activity indicator at the same size token.

## Brand-only components

These have one look on every platform (the J'Donuts design), so there is
no Cupertino branch to differ:

- **AppCtaButton**, **AppPressable**, **AppBadge**, **AppSkeletonBox** /
  **AppShimmer**, **AppNetworkImage**: built from `widgets` and tokens.
- **showAppWheelPickerSheet**: wheels built from `ListWheelScrollView`, so the
  date picker looks the same on iOS and Android.
- **AppTextInput** and **AppCodeInput**: Material `TextField` underneath for
  selection, autofill and IME handling, with the outline drawn by the
  component.
- **SharedAxisPage** / **FadeThroughPage**: custom transitions; product
  detail keeps `buildAdaptivePage` so iOS keeps swipe-back.
