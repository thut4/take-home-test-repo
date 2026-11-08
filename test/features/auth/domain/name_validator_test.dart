import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/features/auth/domain/validators/name_validator.dart';

void main() {
  group('validateFirstName', () {
    test('requires a value', () {
      expect(validateFirstName(''), NameError.required);
    });

    test('treats whitespace only as empty', () {
      expect(validateFirstName('   '), NameError.required);
    });

    test('accepts Latin letters and spaces', () {
      expect(validateFirstName('Ye Min'), isNull);
    });

    test('accepts Myanmar script, including vowel signs and asat', () {
      expect(validateFirstName('ဇော်ဇော်'), isNull);
      expect(validateFirstName('အောင်ကျော်မိုး'), isNull);
    });

    test('rejects ASCII digits', () {
      expect(validateFirstName('Ye Min 2'), NameError.invalidCharacters);
    });

    test('rejects Myanmar digits', () {
      expect(validateFirstName('မောင်၁'), NameError.invalidCharacters);
    });

    test('rejects punctuation', () {
      expect(validateFirstName('Ye-Min'), NameError.invalidCharacters);
    });

    test('accepts exactly 50 characters after trimming', () {
      expect(validateFirstName('  ${'a' * maxNameLength}  '), isNull);
    });

    test('rejects 51 characters', () {
      expect(validateFirstName('a' * (maxNameLength + 1)), NameError.tooLong);
    });
  });

  group('validateLastName', () {
    test('is optional', () {
      expect(validateLastName(''), isNull);
      expect(validateLastName('  '), isNull);
    });

    test('follows the same character rules when present', () {
      expect(validateLastName('Phyoe Win'), isNull);
      expect(validateLastName('Win 9'), NameError.invalidCharacters);
    });

    test('follows the same length rule when present', () {
      expect(validateLastName('b' * (maxNameLength + 1)), NameError.tooLong);
    });
  });
}
