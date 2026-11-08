/// Why a date of birth was rejected.
enum DateOfBirthError { incomplete, invalidDate, inFuture, tooYoung }

/// Youngest age allowed to register.
const minimumAgeYears = 13;

/// Earliest birth year accepted as plausible.
const earliestBirthYear = 1900;

const _monthsInYear = 12;

/// Null when the parts form a real calendar date that is not in the future
/// and makes the person at least [minimumAgeYears] old on [today].
DateOfBirthError? validateDateOfBirth({
  required int? year,
  required int? month,
  required int? day,
  required DateTime today,
}) {
  if (year == null || month == null || day == null) {
    return DateOfBirthError.incomplete;
  }
  if (!isRealDate(year: year, month: month, day: day)) {
    return DateOfBirthError.invalidDate;
  }
  final birthday = DateTime(year, month, day);
  if (birthday.isAfter(DateTime(today.year, today.month, today.day))) {
    return DateOfBirthError.inFuture;
  }
  if (ageOn(birthday, today) < minimumAgeYears) {
    return DateOfBirthError.tooYoung;
  }
  return null;
}

/// True for a date that exists: no 31 April, 29 February only in leap
/// years.
bool isRealDate({required int year, required int month, required int day}) {
  if (year < earliestBirthYear) return false;
  if (month < 1 || month > _monthsInYear) return false;
  return day >= 1 && day <= daysInMonth(year, month);
}

/// Birth years offered by the year picker, newest first: from the latest
/// year that can make someone [minimumAgeYears] (2013 when [today] is in
/// 2026) back to [earliestBirthYear]. Someone born late in the newest year
/// may still be too young; [validateDateOfBirth] catches that.
List<int> selectableBirthYears(DateTime today) => [
  for (var y = today.year - minimumAgeYears; y >= earliestBirthYear; y--) y,
];

/// Days offered by the day picker. All 31 are listed on purpose, so an
/// impossible date (31 April) gets its inline message instead of
/// silently disappearing.
final List<int> selectableDays = List.unmodifiable([
  for (var d = 1; d <= _maxDaysInMonth; d++) d,
]);

const _maxDaysInMonth = 31;

/// Day 0 of the next month is the last day of this one.
int daysInMonth(int year, int month) => DateTime.utc(year, month + 1, 0).day;

/// Whole years between [birthday] and [today]. Someone born on 29 February
/// turns a year older on 1 March in non-leap years.
int ageOn(DateTime birthday, DateTime today) {
  final years = today.year - birthday.year;
  final hadBirthday =
      today.month > birthday.month ||
      (today.month == birthday.month && today.day >= birthday.day);
  return hadBirthday ? years : years - 1;
}
