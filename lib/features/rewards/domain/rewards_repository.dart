import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/rewards/domain/rewards.dart';

abstract interface class RewardsRepository {
  Stream<Result<List<Challenge>>> watchChallenges(RewardTab tab);
}
