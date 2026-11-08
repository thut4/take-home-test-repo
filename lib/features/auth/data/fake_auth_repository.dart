import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:jdonuts/core/clock.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/core/database/database_seeder.dart';
import 'package:jdonuts/core/failure.dart';
import 'package:jdonuts/core/logger.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/auth/data/session_store.dart';
import 'package:jdonuts/features/auth/domain/auth_failure.dart';
import 'package:jdonuts/features/auth/domain/auth_repository.dart';
import 'package:jdonuts/features/auth/domain/user_account.dart';

// Stand-in for a real auth API. Waits about a second per call, accepts the
// code [fakeOtp], and keeps accounts in the local `users` table.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    required AppDatabase database,
    required SessionStore sessionStore,
    this._clock = systemClock,
    this.latency = defaultLatency,
  }) : _db = database,
       _session = sessionStore;

  static const fakeOtp = '123456';
  static const defaultLatency = Duration(seconds: 1);

  final AppDatabase _db;
  final SessionStore _session;
  final Clock _clock;
  final Duration latency;

  // Numbers whose code was sent but not yet verified, and verified ones.
  final _pending = <String>{};
  final _verified = <String>{};

  @override
  Future<Result<bool>> isRegistered(String phone) =>
      _guard('isRegistered', () async => await _findUser(phone) != null);

  @override
  Future<Result<Unit>> sendOtp(String phone) => _guard('sendOtp', () async {
    _verified.remove(phone);
    _pending.add(phone);
    return unit;
  });

  @override
  Future<Result<Unit>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    await Future<void>.delayed(latency);
    if (!_pending.contains(phone) || code != fakeOtp) {
      return const Err(WrongOtpFailure());
    }
    _pending.remove(phone);
    _verified.add(phone);
    return const Ok(unit);
  }

  @override
  Future<Result<UserAccount>> register(UserAccount account) async {
    if (!_verified.contains(account.phone)) {
      return const Err(OtpNotVerifiedFailure());
    }
    return await _guard('register', () async {
      await _db.transaction(() async {
        await _db.into(_db.users).insert(_toRow(account));
        await _db
            .into(_db.members)
            .insertOnConflictUpdate(await _newMember(account.phone));
      });
      await _session.writePhone(account.phone);
      _verified.remove(account.phone);
      return account;
    });
  }

  @override
  Future<Result<UserAccount>> logIn(String phone) async {
    if (!_verified.contains(phone)) return const Err(OtpNotVerifiedFailure());
    final result = await _guard('logIn', () => _findUser(phone));
    switch (result) {
      case Ok(value: final UserAccount account):
        await _session.writePhone(phone);
        _verified.remove(phone);
        return Ok(account);
      case Ok():
        return const Err(PhoneNotRegisteredFailure());
      case Err(:final failure):
        return Err(failure);
    }
  }

  @override
  Future<Result<UserAccount?>> restoreSession() async {
    try {
      final phone = await _session.readPhone();
      if (phone == null) return const Ok(null);
      final account = await _findUser(phone);
      if (account == null) await _session.clear();
      return Ok(account);
    } on Object catch (error, stackTrace) {
      logFailure('restoreSession', error, stackTrace);
      return Err(CacheFailure('$error'));
    }
  }

  @override
  Future<Result<Unit>> logOut() async {
    try {
      await _session.clear();
      return const Ok(unit);
    } on Object catch (error, stackTrace) {
      logFailure('logOut', error, stackTrace);
      return Err(CacheFailure('$error'));
    }
  }

  // Simulated network latency, then [body]; database errors become a
  // typed failure.
  Future<Result<T>> _guard<T>(String where, Future<T> Function() body) async {
    await Future<void>.delayed(latency);
    try {
      return Ok(await body());
    } on Object catch (error, stackTrace) {
      logFailure(where, error, stackTrace);
      return Err(CacheFailure('$error'));
    }
  }

  Future<UserAccount?> _findUser(String phone) async {
    final row = await (_db.select(
      _db.users,
    )..where((u) => u.phone.equals(phone))).getSingleOrNull();
    if (row == null) return null;
    return UserAccount(
      phone: row.phone,
      firstName: row.firstName,
      lastName: row.lastName,
      dateOfBirth: row.dateOfBirth,
    );
  }

  UsersCompanion _toRow(UserAccount account) => UsersCompanion.insert(
    phone: account.phone,
    firstName: account.firstName,
    lastName: Value(account.lastName),
    dateOfBirth: account.dateOfBirth,
    createdAt: _clock(),
  );

  Future<MembersCompanion> _newMember(String phone) async {
    final template =
        await (_db.select(_db.settings)
              ..where((s) => s.key.equals(DatabaseSeeder.memberTemplateKey)))
            .getSingle();
    return DatabaseSeeder.memberFromTemplate(
      phone,
      jsonDecode(template.value) as Map<String, dynamic>,
    );
  }
}
