import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/features/home/home_providers.dart';

@immutable
class SyncStatus {
  const SyncStatus({this.isRefreshing = false, this.lastSyncedAt});

  final bool isRefreshing;
  final DateTime? lastSyncedAt;
}

final catalogSyncProvider = NotifierProvider<CatalogSyncController, SyncStatus>(
  CatalogSyncController.new,
);

// Keeps the local catalogue fresh: refreshes in the background whenever
// the network comes back, and on pull-to-refresh. The UI never waits on
// it; it keeps reading the database.
class CatalogSyncController extends Notifier<SyncStatus> {
  @override
  SyncStatus build() {
    ref.listen(isOnlineProvider, (previous, next) {
      final wasOnline = previous?.value ?? false;
      if ((next.value ?? false) && !wasOnline) unawaited(refresh());
    }, fireImmediately: true);
    return const SyncStatus();
  }

  // Returns the failure (offline, server down), or null on success.
  Future<Failure?> refresh() async {
    if (state.isRefreshing) return null;
    state = SyncStatus(isRefreshing: true, lastSyncedAt: state.lastSyncedAt);
    final result = await ref.read(homeRepositoryProvider).refresh();
    if (!ref.mounted) return null;
    state = SyncStatus(lastSyncedAt: result.valueOrNull ?? state.lastSyncedAt);
    return result.failureOrNull;
  }
}
