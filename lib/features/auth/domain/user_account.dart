import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_account.freezed.dart';

// A registered customer.
@freezed
abstract class UserAccount with _$UserAccount {
  const factory UserAccount({
    // E.164, for example +959254135592.
    required String phone,
    required String firstName,
    required DateTime dateOfBirth,
    String? lastName,
  }) = _UserAccount;

  const UserAccount._();

  String get displayName =>
      [firstName, ?lastName].where((part) => part.isNotEmpty).join(' ');
}
