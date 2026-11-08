import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts/core/providers.dart';
import 'package:jdonuts/features/auth/data/fake_auth_repository.dart';
import 'package:jdonuts/features/auth/data/session_store.dart';
import 'package:jdonuts/features/auth/domain/auth_repository.dart';
import 'package:jdonuts/features/auth/domain/usecases/auth_use_cases.dart';

// Wiring for the auth feature. Swap [authRepositoryProvider] for a real
// API client and nothing above it changes.

final sessionStoreProvider = Provider<SessionStore>(
  (ref) => SecureSessionStore(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FakeAuthRepository(
    database: ref.watch(databaseProvider),
    sessionStore: ref.watch(sessionStoreProvider),
    clock: ref.watch(clockProvider),
  ),
);

final Provider<RequestOtp> requestOtpProvider = Provider(
  (ref) => RequestOtp(ref.watch(authRepositoryProvider)),
);

final Provider<ResendOtp> resendOtpProvider = Provider(
  (ref) => ResendOtp(ref.watch(authRepositoryProvider)),
);

final Provider<VerifyOtp> verifyOtpProvider = Provider(
  (ref) => VerifyOtp(ref.watch(authRepositoryProvider)),
);

final Provider<CompleteRegistration> completeRegistrationProvider = Provider(
  (ref) => CompleteRegistration(
    ref.watch(authRepositoryProvider),
    ref.watch(clockProvider),
  ),
);

final Provider<RestoreSession> restoreSessionProvider = Provider(
  (ref) => RestoreSession(ref.watch(authRepositoryProvider)),
);

final Provider<LogOut> logOutProvider = Provider(
  (ref) => LogOut(ref.watch(authRepositoryProvider)),
);
