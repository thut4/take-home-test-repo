import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';

/// An SVG icon from the app bundle. Multi-colour icons (Google, Facebook)
/// keep their own colours; pass [color] to tint single-colour ones that use
/// `currentColor` (Apple). Same on every platform.
class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(
    this.asset, {
    super.key,
    this.size = AppSize.iconMd,
    this.color,
    this.semanticLabel,
  });

  /// Path from `AppAsset`, for example `AppAsset.facebook`.
  final String asset;
  final double size;
  final Color? color;

  /// Null marks the icon decorative.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final color = this.color;
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(color, BlendMode.srcIn),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}
