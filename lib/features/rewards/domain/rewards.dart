import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jdonuts/features/member/domain/member.dart';

part 'rewards.freezed.dart';

enum RewardTab { earn, gift }

// How a challenge card draws its progress.
enum ChallengeArtwork {
  // The donut colours in by quarters.
  donut,

  // An arc fills over the cup.
  coffee,

  // A gift that can be redeemed; no progress art.
  gift,
}

@freezed
abstract class Challenge with _$Challenge {
  const factory Challenge({
    required String id,
    required RewardTab tab,
    required String title,
    required ChallengeArtwork artwork,
    required String imagePath,
    required int progress,
    required int goal,
    required int points,
  }) = _Challenge;

  const Challenge._();

  bool get isComplete => progress >= goal;

  double get fraction => goal == 0 ? 1 : (progress / goal).clamp(0, 1);
}

// Where a tier sits relative to the member.
enum LadderStatus { reached, current, next, later }

@freezed
abstract class LadderStep with _$LadderStep {
  const factory LadderStep({
    required Tier tier,
    required LadderStatus status,

    // For [LadderStatus.next]: points still needed.
    required int pointsRemaining,
  }) = _LadderStep;
}

// Steps shown on the Rewards tier ladder: the member's tier and the
// [visibleSteps] − 1 tiers above it (or the top [visibleSteps] tiers when
// the member is near the top).
List<LadderStep> buildTierLadder(
  Member member,
  List<Tier> tiers, {
  int visibleSteps = 3,
}) {
  final sorted = [...tiers]..sort((a, b) => a.rank.compareTo(b.rank));
  final index = sorted.indexWhere((t) => t.id == member.tier.id);
  if (index < 0) return const [];
  final start = (sorted.length - visibleSteps).clamp(0, index);
  return [
    for (final tier in sorted.skip(start).take(visibleSteps))
      LadderStep(
        tier: tier,
        status: _status(tier.rank, member.tier.rank),
        pointsRemaining: tier.rank == member.tier.rank + 1
            ? member.pointsToNextTier
            : 0,
      ),
  ];
}

LadderStatus _status(int rank, int memberRank) {
  if (rank < memberRank) return LadderStatus.reached;
  if (rank == memberRank) return LadderStatus.current;
  if (rank == memberRank + 1) return LadderStatus.next;
  return LadderStatus.later;
}
