/// Why a phone number was rejected.
enum PhoneError { empty, invalid }

/// Myanmar's country calling code, shown as a fixed prefix in the field.
const myanmarCountryCode = '+95';

final _separators = RegExp(r'[\s-]');
final _nationalMobile = RegExp(r'^9\d{7,9}$');

/// Normalises what the user typed after the +95 prefix into an E.164
/// number, or returns null when it isn't a valid Myanmar mobile number.
///
/// Rules: strip spaces and dashes; drop a pasted `+95`; drop one leading 0;
/// the rest must be 9 followed by 7 to 9 digits.
/// `09254135592` → `+959254135592`.
String? normalizeMyanmarPhone(String input) {
  var digits = input.replaceAll(_separators, '');
  if (digits.startsWith(myanmarCountryCode)) {
    digits = digits.substring(myanmarCountryCode.length);
  }
  if (digits.startsWith('0')) digits = digits.substring(1);
  if (!_nationalMobile.hasMatch(digits)) return null;
  return '$myanmarCountryCode$digits';
}

/// Null when [input] is a valid number.
PhoneError? validatePhone(String input) {
  if (input.trim().isEmpty) return PhoneError.empty;
  return normalizeMyanmarPhone(input) == null ? PhoneError.invalid : null;
}
