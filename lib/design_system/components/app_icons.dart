import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/theme/app_theme_scope.dart';
import 'package:jdonuts/design_system/tokens/spacing_tokens.dart';
import 'package:material_ui/material_ui.dart' as material;

/// Icon set. Screens use these names, never `Icons.*`, so the icon font
/// stays a design-system detail.
abstract final class AppIcons {
  static const IconData back = material.Icons.arrow_back_rounded;
  static const IconData bell = material.Icons.notifications_none_rounded;
  static const IconData home = material.Icons.home_outlined;
  static const IconData reward = material.Icons.workspace_premium_outlined;
  static const IconData order = material.Icons.donut_small_outlined;
  static const IconData wallet = material.Icons.account_balance_wallet_outlined;
  static const IconData settings = material.Icons.settings_outlined;
  static const IconData add = material.Icons.add_rounded;
  static const IconData remove = material.Icons.remove_rounded;
  static const IconData chevronRight = material.Icons.chevron_right_rounded;
  static const IconData expand = material.Icons.expand_more_rounded;
  static const IconData check = material.Icons.check_rounded;
  static const IconData star = material.Icons.star_rounded;
  static const IconData offline = material.Icons.cloud_off_rounded;
  static const IconData help = material.Icons.question_mark_rounded;
  static const IconData logout = material.Icons.logout_rounded;
  static const IconData error = material.Icons.error_outline_rounded;
  static const IconData brokenImage =
      material.Icons.image_not_supported_outlined;
  static const IconData refresh = material.Icons.refresh_rounded;
  static const IconData language = material.Icons.translate_rounded;
  static const IconData cart = material.Icons.shopping_bag_outlined;
  static const IconData gift = material.Icons.card_giftcard_rounded;
  static const IconData store = material.Icons.storefront_outlined;
  static const IconData lock = material.Icons.lock_outline_rounded;
}

/// White rounded-square back button from the registration screens.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, required this.onPressed, this.label});

  final VoidCallback onPressed;

  /// Screen-reader label; defaults to the platform's "Back".
  final String? label;

  @override
  Widget build(BuildContext context) {
    final label =
        this.label ??
        material.MaterialLocalizations.of(context).backButtonTooltip;
    return material.Material(
      type: material.MaterialType.transparency,
      child: material.IconButton(
        onPressed: onPressed,
        tooltip: label,
        icon: const Icon(AppIcons.back, size: AppSize.iconSm + 4),
        color: context.appTheme.colors.onSurface,
        style: material.IconButton.styleFrom(
          backgroundColor: context.appTheme.colors.surface,
          fixedSize: const Size.square(AppSize.backButton),
          minimumSize: const Size.square(AppSize.backButton),
          padding: EdgeInsets.zero,
          shape: material.RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
        ),
      ),
    );
  }
}
