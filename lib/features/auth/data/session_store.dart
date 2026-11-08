import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Where the signed-in phone number is kept between launches.
abstract interface class SessionStore {
  Future<String?> readPhone();
  Future<void> writePhone(String phone);
  Future<void> clear();
}

// Keychain (iOS) / EncryptedSharedPreferences-backed keystore (Android).
class SecureSessionStore implements SessionStore {
  SecureSessionStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _phoneKey = 'session_phone';
  final FlutterSecureStorage _storage;

  @override
  Future<String?> readPhone() => _storage.read(key: _phoneKey);

  @override
  Future<void> writePhone(String phone) =>
      _storage.write(key: _phoneKey, value: phone);

  @override
  Future<void> clear() => _storage.delete(key: _phoneKey);
}

// For tests and the integration test.
class InMemorySessionStore implements SessionStore {
  InMemorySessionStore([this._phone]);

  String? _phone;

  @override
  Future<String?> readPhone() async => _phone;

  @override
  Future<void> writePhone(String phone) async => _phone = phone;

  @override
  Future<void> clear() async => _phone = null;
}
