import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/auth/auth_providers.dart';
import 'package:jdonuts/features/auth/domain/user_account.dart';

// Who is signed in. The router redirects on every change.
sealed class SessionState {
  const SessionState();
}

final class SignedOut extends SessionState {
  const SignedOut();
}

final class SignedIn extends SessionState {
  const SignedIn(this.account, {this.isNewAccount = false});

  final UserAccount account;

  // Just registered: show Welcome before Home.
  final bool isNewAccount;
}

final sessionControllerProvider =
    NotifierProvider<SessionController, SessionState>(SessionController.new);

class SessionController extends Notifier<SessionState> {
  @override
  SessionState build() => const SignedOut();

  // Reads the stored session. Called once at start-up, before the first
  // frame, so relaunching while signed in opens Home directly.
  Future<void> restore() async {
    final result = await ref.read(restoreSessionProvider)();
    state = switch (result) {
      Ok(value: final UserAccount account) => SignedIn(account),
      _ => const SignedOut(),
    };
  }

  void signIn(UserAccount account, {bool isNewAccount = false}) {
    state = SignedIn(account, isNewAccount: isNewAccount);
  }

  // Welcome was shown; later redirects go straight to Home.
  void welcomeSeen() {
    if (state case SignedIn(:final account, isNewAccount: true)) {
      state = SignedIn(account);
    }
  }

  // Returns the failure, or null once signed out.
  Future<Failure?> logOut() async {
    final result = await ref.read(logOutProvider)();
    if (!ref.mounted) return null;
    if (result case Err(:final failure)) return failure;
    state = const SignedOut();
    return null;
  }
}
