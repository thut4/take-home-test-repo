import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/auth/domain/user_account.dart';

// Authentication back end. The app ships a fake implementation; a real
// API client can replace it without touching the UI. Phone numbers are
// E.164 strings that already passed `normalizeMyanmarPhone`.
abstract interface class AuthRepository {
  Future<Result<bool>> isRegistered(String phone);

  // Sends (or re-sends) a one-time code to [phone].
  Future<Result<Unit>> sendOtp(String phone);

  // Fails with `WrongOtpFailure` when [code] doesn't match.
  Future<Result<Unit>> verifyOtp({required String phone, required String code});

  // Creates the account for a verified number and signs it in.
  Future<Result<UserAccount>> register(UserAccount account);

  // Signs in a verified, registered number.
  Future<Result<UserAccount>> logIn(String phone);

  // The signed-in account from the stored session, or null.
  Future<Result<UserAccount?>> restoreSession();

  Future<Result<Unit>> logOut();
}
