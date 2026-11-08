import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts/core/database/preferences_store.dart';
import 'package:jdonuts/core/providers.dart';

final Provider<PreferencesStore> preferencesStoreProvider = Provider(
  (ref) => PreferencesStore(ref.watch(databaseProvider)),
);

/// The app language. Null follows the device; a choice made in Settings is
/// saved and restored on the next launch.
final localeControllerProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);

class LocaleController extends Notifier<Locale?> {
  static const _key = 'locale';
  static const supported = [Locale('en'), Locale('my')];

  @override
  Locale? build() {
    unawaited(_load());
    return null;
  }

  Future<void> _load() async {
    final code = await ref.read(preferencesStoreProvider).read(_key);
    if (code != null && ref.mounted) state = Locale(code);
  }

  /// Switches between English and Burmese.
  Future<void> toggle(Locale current) async {
    final next = current.languageCode == 'my'
        ? supported.first
        : supported.last;
    state = next;
    await ref.read(preferencesStoreProvider).write(_key, next.languageCode);
  }
}
