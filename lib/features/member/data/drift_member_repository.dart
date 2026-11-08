import 'package:drift/drift.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/core/database/watch_result.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/member/domain/member.dart';
import 'package:jdonuts/features/member/domain/member_repository.dart';

class DriftMemberRepository implements MemberRepository {
  DriftMemberRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<Result<Member>> watchMember(String phone) {
    final query = _db.select(_db.members).join([
      innerJoin(_db.users, _db.users.phone.equalsExp(_db.members.phone)),
      innerJoin(_db.tiers, _db.tiers.id.equalsExp(_db.members.tierId)),
    ])..where(_db.members.phone.equals(phone));
    final tiers = _db.select(_db.tiers)
      ..orderBy([(t) => OrderingTerm(expression: t.rank)]);
    final combined = query.watchSingleOrNull().asyncMap((row) async {
      if (row == null) throw NotFoundFailure('member $phone');
      return _toMember(row, await tiers.get());
    });
    return watchResult('watchMember', combined);
  }

  @override
  Stream<Result<List<Tier>>> watchTiers() {
    final query = _db.select(_db.tiers)
      ..orderBy([(t) => OrderingTerm(expression: t.rank)]);
    return watchResult(
      'watchTiers',
      query.watch().map((rows) => rows.map(_toTier).toList()),
    );
  }

  Member _toMember(TypedResult row, List<TierRow> allTiers) {
    final member = row.readTable(_db.members);
    final user = row.readTable(_db.users);
    final tier = row.readTable(_db.tiers);
    final next = allTiers.where((t) => t.rank == tier.rank + 1).firstOrNull;
    return Member(
      phone: member.phone,
      firstName: user.firstName,
      lastName: user.lastName,
      photoPath: member.photoPath,
      tier: _toTier(tier),
      nextTier: next == null ? null : _toTier(next),
      tierPoints: member.tierPoints,
      totalPoints: member.totalPoints,
      notificationCount: member.notificationCount,
      rewardCount: member.rewardCount,
    );
  }

  static Tier _toTier(TierRow row) => Tier(
    id: row.id,
    name: row.name,
    rank: row.rank,
    pointsToNext: row.pointsToNext,
  );
}
