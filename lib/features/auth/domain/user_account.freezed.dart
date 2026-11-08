// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserAccount {

/// E.164, for example +959254135592.
 String get phone; String get firstName; DateTime get dateOfBirth; String? get lastName;
/// Create a copy of UserAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserAccountCopyWith<UserAccount> get copyWith => _$UserAccountCopyWithImpl<UserAccount>(this as UserAccount, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserAccount;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserAccount&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.dateOfBirth, _this.dateOfBirth) || other.dateOfBirth == _this.dateOfBirth)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName));
}


@override
int get hashCode {
  final _this = this as UserAccount;
  return Object.hash(runtimeType,_this.phone,_this.firstName,_this.dateOfBirth,_this.lastName);
}

@override
String toString() {
  final _this = this as UserAccount;
  return 'UserAccount(phone: ${_this.phone}, firstName: ${_this.firstName}, dateOfBirth: ${_this.dateOfBirth}, lastName: ${_this.lastName})';
}


}

/// @nodoc
abstract mixin class $UserAccountCopyWith<$Res>  {
  factory $UserAccountCopyWith(UserAccount value, $Res Function(UserAccount) _then) = _$UserAccountCopyWithImpl;
@useResult
$Res call({
 String phone, String firstName, DateTime dateOfBirth, String? lastName
});




}
/// @nodoc
class _$UserAccountCopyWithImpl<$Res>
    implements $UserAccountCopyWith<$Res> {
  _$UserAccountCopyWithImpl(this._self, this._then);

  final UserAccount _self;
  final $Res Function(UserAccount) _then;

/// Create a copy of UserAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,Object? firstName = null,Object? dateOfBirth = null,Object? lastName = freezed,}) {
  return _then(UserAccount(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserAccount].
extension UserAccountPatterns on UserAccount {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserAccount() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserAccount value)  $default,){
final _that = this;
switch (_that) {
case _UserAccount():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserAccount value)?  $default,){
final _that = this;
switch (_that) {
case _UserAccount() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phone,  String firstName,  DateTime dateOfBirth,  String? lastName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserAccount() when $default != null:
return $default(_that.phone,_that.firstName,_that.dateOfBirth,_that.lastName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phone,  String firstName,  DateTime dateOfBirth,  String? lastName)  $default,) {final _that = this;
switch (_that) {
case _UserAccount():
return $default(_that.phone,_that.firstName,_that.dateOfBirth,_that.lastName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phone,  String firstName,  DateTime dateOfBirth,  String? lastName)?  $default,) {final _that = this;
switch (_that) {
case _UserAccount() when $default != null:
return $default(_that.phone,_that.firstName,_that.dateOfBirth,_that.lastName);case _:
  return null;

}
}

}

/// @nodoc


class _UserAccount extends UserAccount {
  const _UserAccount({required this.phone, required this.firstName, required this.dateOfBirth, this.lastName}): super._();
  

/// E.164, for example +959254135592.
@override final  String phone;
@override final  String firstName;
@override final  DateTime dateOfBirth;
@override final  String? lastName;

/// Create a copy of UserAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserAccountCopyWith<_UserAccount> get copyWith => __$UserAccountCopyWithImpl<_UserAccount>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserAccount&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.lastName, lastName) || other.lastName == lastName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,phone,firstName,dateOfBirth,lastName);
}

@override
String toString() {
    return 'UserAccount(phone: $phone, firstName: $firstName, dateOfBirth: $dateOfBirth, lastName: $lastName)';
}


}

/// @nodoc
abstract mixin class _$UserAccountCopyWith<$Res> implements $UserAccountCopyWith<$Res> {
  factory _$UserAccountCopyWith(_UserAccount value, $Res Function(_UserAccount) _then) = __$UserAccountCopyWithImpl;
@override @useResult
$Res call({
 String phone, String firstName, DateTime dateOfBirth, String? lastName
});




}
/// @nodoc
class __$UserAccountCopyWithImpl<$Res>
    implements _$UserAccountCopyWith<$Res> {
  __$UserAccountCopyWithImpl(this._self, this._then);

  final _UserAccount _self;
  final $Res Function(_UserAccount) _then;

/// Create a copy of UserAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? firstName = null,Object? dateOfBirth = null,Object? lastName = freezed,}) {
  return _then(_UserAccount(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
