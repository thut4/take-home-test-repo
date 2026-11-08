import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/l10n/gen/app_localizations.dart';

export 'package:jdonuts/l10n/gen/app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension AppFormatting on AppLocalizations {
  /// Thousands separators in the active locale: 3,200.
  String number(int value) =>
      NumberFormat.decimalPattern(localeName).format(value);

  /// 3,200 MMK.
  String mmk(int value) => priceMmk(number(value));

  /// User-facing message for a failure. Unknown types get the generic text;
  /// the original error was already logged where it happened.
  String failureMessage(Failure failure) => switch (failure) {
    NetworkFailure() => networkError,
    _ => genericError,
  };
}
