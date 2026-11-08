import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:jdonuts/core/app_assets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/l10n/l10n.dart';

// Google, Apple and Facebook buttons. No real integration: each opens a
// placeholder sheet.
class SocialSignInRow extends StatelessWidget {
  const SocialSignInRow({super.key});

  static const List<({String name, String icon})> _providers = [
    (name: 'Google', icon: AppAsset.google),
    (name: 'Apple', icon: AppAsset.apple),
    (name: 'Facebook', icon: AppAsset.facebook),
  ];

  void _explain(BuildContext context, String provider) {
    final l10n = context.l10n;
    unawaited(
      showAppInfoSheet(
        context,
        title: l10n.comingSoonTitle(provider),
        message: l10n.socialUnavailable(provider),
        closeLabel: l10n.close,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final provider in _providers)
          _SocialButton(
            key: Key('social-${provider.name.toLowerCase()}'),
            label: l10n.continueWith(provider.name),
            icon: provider.icon,
            onPressed: () => _explain(context, provider.name),
          ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AppPressable(
      onPressed: onPressed,
      semanticLabel: label,
      child: SizedBox.square(
        dimension: AppSize.minTouchTarget,
        child: Center(
          // The Apple mark is single-colour (currentColor); the others keep
          // their brand colours.
          child: AppSvgIcon(
            icon,
            color: icon == AppAsset.apple
                ? context.appTheme.colors.onSurface
                : null,
          ),
        ),
      ),
    );
  }
}
