import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/features/member/domain/member.dart';
import 'package:jdonuts/features/rewards/domain/rewards.dart';

const _tiers = [
  Tier(id: 'bronze', name: 'Bronze', rank: 0, pointsToNext: 1000),
  Tier(id: 'silver', name: 'Silver', rank: 1, pointsToNext: 2000),
  Tier(id: 'gold', name: 'Gold', rank: 2, pointsToNext: 5000),
  Tier(id: 'platinum', name: 'Platinum', rank: 3),
];

Member _member(int tierIndex, {int tierPoints = 1500}) => Member(
  phone: '+959123456789',
  firstName: 'Hania',
  photoPath: 'brand/member_avatar.png',
  tier: _tiers[tierIndex],
  nextTier: tierIndex + 1 < _tiers.length ? _tiers[tierIndex + 1] : null,
  tierPoints: tierPoints,
  totalPoints: 680000,
  notificationCount: 2,
  rewardCount: 3,
);

void main() {
  group('Member', () {
    test('points to the next tier come from tier points, not the total', () {
      expect(_member(1).pointsToNextTier, 500);
      expect(_member(1).tierProgress, 0.75);
    });

    test('the top tier has nothing left to earn', () {
      expect(_member(3).pointsToNextTier, 0);
      expect(_member(3).tierProgress, 1);
    });
  });

  group('buildTierLadder', () {
    test('a Silver member sees Silver, Gold, Platinum', () {
      final ladder = buildTierLadder(_member(1), _tiers);
      expect(ladder.map((s) => s.tier.name), ['Silver', 'Gold', 'Platinum']);
      expect(ladder.map((s) => s.status), [
        LadderStatus.current,
        LadderStatus.next,
        LadderStatus.later,
      ]);
      expect(ladder[1].pointsRemaining, 500);
    });

    test('a Platinum member sees the top three, lower ones as reached', () {
      final ladder = buildTierLadder(_member(3), _tiers);
      expect(ladder.map((s) => s.tier.name), ['Silver', 'Gold', 'Platinum']);
      expect(ladder.last.status, LadderStatus.current);
      expect(ladder.first.status, LadderStatus.reached);
    });
  });

  group('Challenge', () {
    const challenge = Challenge(
      id: 'c',
      tab: RewardTab.earn,
      title: 'Drink 12 cups americano',
      artwork: ChallengeArtwork.coffee,
      imagePath: 'products/iced_latte.png',
      progress: 9,
      goal: 12,
      points: 100,
    );

    test('reports its fraction and completion', () {
      expect(challenge.fraction, 0.75);
      expect(challenge.isComplete, isFalse);
      expect(challenge.copyWith(progress: 12).isComplete, isTrue);
    });
  });
}
