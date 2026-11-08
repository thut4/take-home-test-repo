import 'package:cupertino_ui/cupertino_ui.dart' as cupertino;
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/components/target.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';
import 'package:material_ui/material_ui.dart' as material;

enum AdaptiveLoadingIndicatorSize {
  small(AppSize.iconSm),
  medium(AppSize.iconMd),
  large(AppSize.iconLg);

  AdaptiveLoadingIndicatorSize(this.dimension);

  final double dimension;
}

// Indeterminate spinner: Material circular indicator or iOS activity
// indicator.
class AdaptiveLoadingIndicator extends StatelessWidget {
  const AdaptiveLoadingIndicator({
    super.key,
    this.size = AdaptiveLoadingIndicatorSize.medium,
    this.color,
    this.semanticLabel = 'Loading',
  });

  final AdaptiveLoadingIndicatorSize size;

  // Defaults to the primary colour.
  final Color? color;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? context.appTheme.colors.primary;
    final dimension = size.dimension;

    final Widget indicator;
    if (useCupertino) {
      indicator = cupertino.CupertinoActivityIndicator(
        color: color,
        radius: dimension / 2,
      );
    } else {
      indicator = material.CircularProgressIndicator(
        color: color,
        strokeWidth: size == AdaptiveLoadingIndicatorSize.small ? 2 : 3,
      );
    }

    return Semantics(
      label: semanticLabel,
      child: SizedBox.square(dimension: dimension, child: indicator),
    );
  }
}
