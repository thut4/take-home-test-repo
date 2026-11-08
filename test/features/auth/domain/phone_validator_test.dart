import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/features/auth/domain/validators/phone_validator.dart';

void main() {
  group('normalizeMyanmarPhone', () {
    test('drops the leading 0 and adds +95 (the brief example)', () {
      expect(normalizeMyanmarPhone('09254135592'), '+959254135592');
    });

    test('strips spaces and dashes before checking', () {
      expect(normalizeMyanmarPhone('09 254-135 592'), '+959254135592');
    });

    test('accepts a number typed without the leading 0', () {
      expect(normalizeMyanmarPhone('9254135592'), '+959254135592');
    });

    test('accepts a pasted number that already has +95', () {
      expect(normalizeMyanmarPhone('+95 9 254 135 592'), '+959254135592');
    });

    test('accepts the shortest number: 9 followed by 7 digits', () {
      expect(normalizeMyanmarPhone('091234567'), '+9591234567');
    });

    test('accepts the longest number: 9 followed by 9 digits', () {
      expect(normalizeMyanmarPhone('09123456789'), '+959123456789');
    });

    test('rejects 9 followed by only 6 digits', () {
      expect(normalizeMyanmarPhone('09123456'), isNull);
    });

    test('rejects 9 followed by 10 digits', () {
      expect(normalizeMyanmarPhone('091234567890'), isNull);
    });

    test('rejects a number that does not start with 9 after the 0', () {
      expect(normalizeMyanmarPhone('08254135592'), isNull);
    });

    test('strips only one leading 0', () {
      expect(normalizeMyanmarPhone('009254135592'), isNull);
    });

    test('rejects letters and other symbols', () {
      expect(normalizeMyanmarPhone('09254a35592'), isNull);
      expect(normalizeMyanmarPhone('(09)254135592'), isNull);
    });
  });

  group('validatePhone', () {
    test('reports an empty field', () {
      expect(validatePhone('   '), PhoneError.empty);
    });

    test('reports an invalid number', () {
      expect(validatePhone('12345'), PhoneError.invalid);
    });

    test('passes a valid number', () {
      expect(validatePhone('09254135592'), isNull);
    });
  });
}
