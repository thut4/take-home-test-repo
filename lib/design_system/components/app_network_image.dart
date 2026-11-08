import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/app_icons.dart';
import 'package:jdonuts/design_system/components/app_motion.dart';
import 'package:jdonuts/design_system/components/app_skeleton.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/motion_tokens.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';

/// Image that works offline. It loads [url] through a disk cache; until the
/// network copy arrives (or when it can't), it shows [fallbackAsset], the
/// copy bundled with the app. With neither, it shows a skeleton while
/// loading and a broken-image state on error. Same on every platform.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fallbackAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.semanticLabel,
  });

  final String url;

  /// Bundled copy, for example `assets/images/products/coconut.png`.
  final String? fallbackAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  /// Describe the image for screen readers; null marks it decorative.
  final String? semanticLabel;

  /// Tests turn the network off so no cache database is opened.
  @visibleForTesting
  static bool debugNetworkEnabled = true;

  @override
  Widget build(BuildContext context) {
    final image = debugNetworkEnabled
        ? CachedNetworkImage(
            imageUrl: url,
            width: width,
            height: height,
            fit: fit,
            fadeInDuration: context.motion(AppMotion.medium),
            placeholder: (context, _) => _fallback(loading: true),
            errorWidget: (context, _, _) => _fallback(loading: false),
          )
        : _fallback(loading: false);
    return Semantics(
      image: semanticLabel != null,
      label: semanticLabel,
      excludeSemantics: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: image,
      ),
    );
  }

  Widget _fallback({required bool loading}) {
    final asset = fallbackAsset;
    final placeholder = loading
        ? AppShimmer(
            child: AppSkeletonBox(width: width, height: height),
          )
        : _BrokenImage(width: width, height: height);
    if (asset == null) return placeholder;
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, _, _) => placeholder,
    );
  }
}

class _BrokenImage extends StatelessWidget {
  const _BrokenImage({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    return Container(
      width: width,
      height: height,
      color: colors.surfaceMuted,
      alignment: Alignment.center,
      child: Icon(
        AppIcons.brokenImage,
        color: colors.onSurfaceMuted,
        size: AppSize.iconMd,
      ),
    );
  }
}
