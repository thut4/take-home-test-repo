import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts/features/auth/domain/validators/date_of_birth_validator.dart';

void main() {
  final today = DateTime(2026, 11, 8);

  DateOfBirthError? validate(int? year, int? month, int? day) =>
      validateDateOfBirth(year: year, month: month, day: day, today: today);

  group('validateDateOfBirth', () {
    test('passes the design example (1 May 1980)', () {
      expect(validate(1980, 5, 1), isNull);
    });

    test('reports missing parts as incomplete', () {
      expect(validate(null, 5, 1), DateOfBirthError.incomplete);
      expect(validate(1980, null, 1), DateOfBirthError.incomplete);
      expect(validate(1980, 5, null), DateOfBirthError.incomplete);
    });

    test('rejects 31 April', () {
      expect(validate(1990, 4, 31), DateOfBirthError.invalidDate);
    });

    test('accepts 29 February in a leap year', () {
      expect(validate(2000, 2, 29), isNull);
    });

    test('rejects 29 February in a non-leap year', () {
      expect(validate(2001, 2, 29), DateOfBirthError.invalidDate);
    });

    test('rejects 29 February 1900 (century, not a leap year)', () {
      expect(validate(1900, 2, 29), DateOfBirthError.invalidDate);
    });

    test('rejects month 13 and day 0', () {
      expect(validate(1990, 13, 1), DateOfBirthError.invalidDate);
      expect(validate(1990, 1, 0), DateOfBirthError.invalidDate);
    });

    test('rejects years before the earliest plausible year', () {
      expect(
        validate(earliestBirthYear - 1, 1, 1),
        DateOfBirthError.invalidDate,
      );
    });

    test('rejects a date in the future', () {
      expect(validate(2026, 11, 9), DateOfBirthError.inFuture);
    });

    test('rejects someone who turns 13 tomorrow', () {
      expect(validate(2013, 11, 9), DateOfBirthError.tooYoung);
    });

    test('accepts someone who turns 13 today', () {
      expect(validate(2013, 11, 8), isNull);
    });

    test('uses the named minimum age', () {
      expect(minimumAgeYears, 13);
    });
  });

  group('ageOn', () {
    test('counts a 29 February birthday from 1 March in non-leap years', () {
      final leapling = DateTime(2012, 2, 29);
      expect(ageOn(leapling, DateTime(2025, 2, 28)), 12);
      expect(ageOn(leapling, DateTime(2025, 3)), 13);
    });
  });

  group('selectableBirthYears', () {
    test('starts at the latest year that can make someone 13', () {
      final years = selectableBirthYears(today);
      expect(years.first, 2013);
      expect(years.last, earliestBirthYear);
      expect(years, isNot(contains(2014)));
    });

    test('moves forward with the calendar', () {
      expect(selectableBirthYears(DateTime(2027)).first, 2014);
    });
  });

  test('the day picker lists 1 to 31, so impossible dates get a message', () {
    expect(selectableDays.first, 1);
    expect(selectableDays.last, 31);
  });
}
