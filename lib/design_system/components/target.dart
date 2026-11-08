import 'package:flutter/foundation.dart';

/// How the design system picks a renderer.
enum RendererPolicy {
  /// `material_ui` on every platform, styled by tokens, so iOS matches the
  /// custom design. Routes keep the native iOS slide and swipe-back.
  brand,

  /// `cupertino_ui` on iOS and macOS, `material_ui` elsewhere. Web always
  /// uses Material.
  platform,
}

/// The active policy. Set it once in `main()` before `runApp`.
RendererPolicy rendererPolicy = RendererPolicy.brand;

TargetPlatform? _platformOverride;

/// The single renderer decision. Components read this; nothing else checks
/// [rendererPolicy] or [defaultTargetPlatform].
bool get useCupertino {
  if (rendererPolicy == RendererPolicy.brand || kIsWeb) return false;
  final platform = _platformOverride ?? defaultTargetPlatform;
  return platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
}

/// Forces the platform [useCupertino] sees. Tests only.
@visibleForTesting
void debugOverrideTargetPlatform(TargetPlatform? platform) {
  _platformOverride = platform;
}

/// Clears the platform override and restores [RendererPolicy.brand].
/// Call it in `tearDown`.
@visibleForTesting
void debugResetRendererOverrides() {
  _platformOverride = null;
  rendererPolicy = RendererPolicy.brand;
}
