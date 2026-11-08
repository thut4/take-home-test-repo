import 'package:drift/drift.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/core/database/watch_result.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/rewards/domain/rewards.dart';
import 'package:jdonuts/features/rewards/domain/rewards_repository.dart';

class DriftRewardsRepository implements RewardsRepository {
  DriftRewardsRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<Result<List<Challenge>>> watchChallenges(RewardTab tab) {
    final query = _db.select(_db.challenges)
      ..where((c) => c.tab.equals(tab.name))
      ..orderBy([(c) => OrderingTerm(expression: c.sortOrder)]);
    return watchResult(
      'watchChallenges',
      query.watch().map((rows) => rows.map(_toChallenge).toList()),
    );
  }

  static Challenge _toChallenge(ChallengeRow row) => Challenge(
    id: row.id,
    tab: RewardTab.values.byName(row.tab),
    title: row.title,
    artwork: ChallengeArtwork.values.byName(row.artwork),
    imagePath: row.imagePath,
    progress: row.progress,
    goal: row.goal,
    points: row.points,
  );
}
