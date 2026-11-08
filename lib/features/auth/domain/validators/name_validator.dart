/// Why a name was rejected.
enum NameError { required, tooLong, invalidCharacters }

/// Longest name accepted, counted in Unicode code points after trimming.
const maxNameLength = 50;

/// Letters (any script) and their combining marks, plus spaces. Burmese
/// vowel signs, tone marks and the asat are combining marks (\p{M}), so a
/// letters-only rule would reject real Myanmar names. Digits of any script,
/// including Myanmar ၀–၉, fall outside both classes.
final _nameCharacters = RegExp(r'^[\p{L}\p{M} ]+$', unicode: true);

/// First name: required.
NameError? validateFirstName(String input) {
  final name = input.trim();
  if (name.isEmpty) return NameError.required;
  return _checkCharacters(name);
}

/// Last name: optional (many Myanmar names have no family name), but when
/// present it follows the same character rules.
NameError? validateLastName(String input) {
  final name = input.trim();
  if (name.isEmpty) return null;
  return _checkCharacters(name);
}

NameError? _checkCharacters(String name) {
  if (name.runes.length > maxNameLength) return NameError.tooLong;
  if (!_nameCharacters.hasMatch(name)) return NameError.invalidCharacters;
  return null;
}
