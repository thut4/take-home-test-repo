import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show StreamProviderFamily;
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/features/member/member_providers.dart';
import 'package:jdonuts/features/rewards/data/drift_rewards_repository.dart';
import 'package:jdonuts/features/rewards/domain/rewards.dart';
import 'package:jdonuts/features/rewards/domain/rewards_repository.dart';

final rewardsRepositoryProvider = Provider<RewardsRepository>(
  (ref) => DriftRewardsRepository(ref.watch(databaseProvider)),
);

final StreamProviderFamily<List<Challenge>, RewardTab> challengesProvider =
    StreamProvider.autoDispose.family<List<Challenge>, RewardTab>(
      (ref, tab) => ref
          .watch(rewardsRepositoryProvider)
          .watchChallenges(tab)
          .map((result) => result.getOrThrow()),
    );

/// The tier ladder, derived from the same member record Home shows.
final Provider<AsyncValue<List<LadderStep>>> tierLadderProvider =
    Provider.autoDispose<AsyncValue<List<LadderStep>>>((ref) {
      final member = ref.watch(currentMemberProvider);
      final tiers = ref.watch(tiersProvider);
      return switch ((member, tiers)) {
        (AsyncData(value: final m), AsyncData(value: final t)) => AsyncData(
          buildTierLadder(m, t),
        ),
        (AsyncError(:final error, :final stackTrace), _) ||
        (
          _,
          AsyncError(:final error, :final stackTrace),
        ) => AsyncError(error, stackTrace),
        _ => const AsyncLoading(),
      };
    });

/// Bumped by the bottom navigation every time Rewards is opened, so its
/// entrance animation replays.
final rewardsEntranceProvider = NotifierProvider<RewardsEntrance, int>(
  RewardsEntrance.new,
);

class RewardsEntrance extends Notifier<int> {
  @override
  int build() => 0;

  void replay() => state++;
}
