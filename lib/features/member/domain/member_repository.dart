import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/member/domain/member.dart';

abstract interface class MemberRepository {
  // The member for [phone], updated whenever the record changes.
  Stream<Result<Member>> watchMember(String phone);

  // All tiers, lowest first.
  Stream<Result<List<Tier>>> watchTiers();
}
