import 'dart:math' as math;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'member.freezed.dart';

// A loyalty tier. [pointsToNext] is how many tier points it takes to move
// up from this tier; null for the top tier.
@freezed
abstract class Tier with _$Tier {
  const factory Tier({
    required String id,
    required String name,
    required int rank,
    int? pointsToNext,
  }) = _Tier;
}

// The signed-in customer's loyalty profile. One record drives both Home
// and Rewards.
//
// [tierPoints] measure progress inside the current tier. [totalPoints] is
// the lifetime counter shown on Rewards; it is not used for tier maths.
@freezed
abstract class Member with _$Member {
  const factory Member({
    required String phone,
    required String firstName,
    required String photoPath,
    required Tier tier,
    required int tierPoints,
    required int totalPoints,
    required int notificationCount,
    required int rewardCount,
    String? lastName,
    Tier? nextTier,
  }) = _Member;

  const Member._();

  String get displayName =>
      [firstName, ?lastName].where((part) => part.isNotEmpty).join(' ');

  // Points still needed to reach [nextTier]; 0 at the top tier.
  int get pointsToNextTier {
    final span = tier.pointsToNext;
    if (span == null || nextTier == null) return 0;
    return math.max(0, span - tierPoints);
  }

  // Progress through the current tier, 0 to 1.
  double get tierProgress {
    final span = tier.pointsToNext;
    if (span == null || span == 0 || nextTier == null) return 1;
    return (tierPoints / span).clamp(0, 1).toDouble();
  }
}
