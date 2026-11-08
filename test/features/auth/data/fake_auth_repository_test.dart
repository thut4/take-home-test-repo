import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/core/database/app_database.dart';
import 'package:jdonuts/core/result.dart';
import 'package:jdonuts/features/auth/data/fake_auth_repository.dart';
import 'package:jdonuts/features/auth/data/session_store.dart';
import 'package:jdonuts/features/auth/domain/auth_failure.dart';
import 'package:jdonuts/features/auth/domain/user_account.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late InMemorySessionStore session;
  late FakeAuthRepository repository;
  const phone = '+959254135592';

  setUp(() {
    db = seededDatabase();
    session = InMemorySessionStore();
    repository = FakeAuthRepository(
      database: db,
      sessionStore: session,
      latency: Duration.zero,
    );
  });

  tearDown(() => db.close());

  test('the seeded demo account is registered', () async {
    expect(await repository.isRegistered('+959123456789'), const Ok(true));
    expect(await repository.isRegistered(phone), const Ok(false));
  });

  test('accepts only the fake code 123456', () async {
    await repository.sendOtp(phone);
    final wrong = await repository.verifyOtp(phone: phone, code: '654321');
    expect(wrong.failureOrNull, isA<WrongOtpFailure>());
    final right = await repository.verifyOtp(
      phone: phone,
      code: FakeAuthRepository.fakeOtp,
    );
    expect(right, const Ok(unit));
  });

  test('refuses to register a number whose code was not verified', () async {
    final result = await repository.register(
      UserAccount(
        phone: phone,
        firstName: 'Ye Min',
        dateOfBirth: DateTime(1980),
      ),
    );
    expect(result.failureOrNull, isA<OtpNotVerifiedFailure>());
  });

  test('registers, stores the session and survives a restore', () async {
    await repository.sendOtp(phone);
    await repository.verifyOtp(phone: phone, code: FakeAuthRepository.fakeOtp);
    await repository.register(
      UserAccount(
        phone: phone,
        firstName: 'Ye Min',
        dateOfBirth: DateTime(1980),
      ),
    );
    expect(await session.readPhone(), phone);
    final restored = await repository.restoreSession();
    expect(restored.valueOrNull?.firstName, 'Ye Min');
  });

  test('creates the member record from the seed template', () async {
    await repository.sendOtp(phone);
    await repository.verifyOtp(phone: phone, code: FakeAuthRepository.fakeOtp);
    await repository.register(
      UserAccount(
        phone: phone,
        firstName: 'Ye Min',
        dateOfBirth: DateTime(1980),
      ),
    );
    final member = await (db.select(
      db.members,
    )..where((m) => m.phone.equals(phone))).getSingle();
    expect(member.tierId, 'silver');
    expect(member.totalPoints, 680000);
  });

  test('log out clears the stored session', () async {
    await session.writePhone('+959123456789');
    await repository.logOut();
    expect(await repository.restoreSession(), const Ok<UserAccount?>(null));
  });
}
