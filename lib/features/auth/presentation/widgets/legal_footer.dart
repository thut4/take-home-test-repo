import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:jdonuts/design_system/design_system.dart';
import 'package:jdonuts/l10n/l10n.dart';

// "By continuing, you acknowledge ... Terms of Use and Privacy Policy."
// The links open a placeholder sheet.
class LegalFooter extends StatefulWidget {
  const LegalFooter({super.key});

  @override
  State<LegalFooter> createState() => _LegalFooterState();
}

class _LegalFooterState extends State<LegalFooter> {
  late final TapGestureRecognizer _terms = TapGestureRecognizer();
  late final TapGestureRecognizer _privacy = TapGestureRecognizer();

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    super.dispose();
  }

  void _open(String document) {
    final l10n = context.l10n;
    unawaited(
      showAppInfoSheet(
        context,
        title: document,
        message: l10n.legalUnavailable(document),
        closeLabel: l10n.close,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = context.appTheme;
    final link = theme.text.caption.copyWith(color: theme.colors.accent);
    _terms.onTap = () => _open(l10n.termsOfUse);
    _privacy.onTap = () => _open(l10n.privacyPolicy);
    return Text.rich(
      TextSpan(
        style: theme.text.caption,
        children: [
          TextSpan(text: l10n.legalPrefix),
          TextSpan(text: l10n.termsOfUse, style: link, recognizer: _terms),
          TextSpan(text: l10n.legalAnd),
          TextSpan(text: l10n.privacyPolicy, style: link, recognizer: _privacy),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
