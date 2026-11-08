import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/features/auth/presentation/controllers/session_controller.dart';
import 'package:jdonuts/features/member/data/drift_member_repository.dart';
import 'package:jdonuts/features/member/domain/member.dart';
import 'package:jdonuts/features/member/domain/member_repository.dart';

final memberRepositoryProvider = Provider<MemberRepository>(
  (ref) => DriftMemberRepository(ref.watch(databaseProvider)),
);

// The signed-in member. Home and Rewards both watch this one record.
final StreamProvider<Member> currentMemberProvider =
    StreamProvider.autoDispose<Member>((ref) {
      final session = ref.watch(sessionControllerProvider);
      if (session is! SignedIn) return const Stream.empty();
      return ref
          .watch(memberRepositoryProvider)
          .watchMember(session.account.phone)
          .map((result) => result.getOrThrow());
    });

final StreamProvider<List<Tier>> tiersProvider =
    StreamProvider.autoDispose<List<Tier>>(
      (ref) => ref
          .watch(memberRepositoryProvider)
          .watchTiers()
          .map((result) => result.getOrThrow()),
    );
