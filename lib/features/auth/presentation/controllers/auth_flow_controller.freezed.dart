// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_flow_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthFlowState {

 AuthMode get mode; String get phoneInput; String get firstName; String get lastName; bool get isSubmitting; String? get phone; DateTime? get otpSentAt; int? get month; int? get day; int? get year;
/// Create a copy of AuthFlowState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthFlowStateCopyWith<AuthFlowState> get copyWith => _$AuthFlowStateCopyWithImpl<AuthFlowState>(this as AuthFlowState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AuthFlowState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFlowState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.phoneInput, _this.phoneInput) || other.phoneInput == _this.phoneInput)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.otpSentAt, _this.otpSentAt) || other.otpSentAt == _this.otpSentAt)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.year, _this.year) || other.year == _this.year));
}


@override
int get hashCode {
  final _this = this as AuthFlowState;
  return Object.hash(runtimeType,_this.mode,_this.phoneInput,_this.firstName,_this.lastName,_this.isSubmitting,_this.phone,_this.otpSentAt,_this.month,_this.day,_this.year);
}

@override
String toString() {
  final _this = this as AuthFlowState;
  return 'AuthFlowState(mode: ${_this.mode}, phoneInput: ${_this.phoneInput}, firstName: ${_this.firstName}, lastName: ${_this.lastName}, isSubmitting: ${_this.isSubmitting}, phone: ${_this.phone}, otpSentAt: ${_this.otpSentAt}, month: ${_this.month}, day: ${_this.day}, year: ${_this.year})';
}


}

/// @nodoc
abstract mixin class $AuthFlowStateCopyWith<$Res>  {
  factory $AuthFlowStateCopyWith(AuthFlowState value, $Res Function(AuthFlowState) _then) = _$AuthFlowStateCopyWithImpl;
@useResult
$Res call({
 AuthMode mode, String phoneInput, String firstName, String lastName, bool isSubmitting, String? phone, DateTime? otpSentAt, int? month, int? day, int? year
});




}
/// @nodoc
class _$AuthFlowStateCopyWithImpl<$Res>
    implements $AuthFlowStateCopyWith<$Res> {
  _$AuthFlowStateCopyWithImpl(this._self, this._then);

  final AuthFlowState _self;
  final $Res Function(AuthFlowState) _then;

/// Create a copy of AuthFlowState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? phoneInput = null,Object? firstName = null,Object? lastName = null,Object? isSubmitting = null,Object? phone = freezed,Object? otpSentAt = freezed,Object? month = freezed,Object? day = freezed,Object? year = freezed,}) {
  return _then(AuthFlowState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AuthMode,phoneInput: null == phoneInput ? _self.phoneInput : phoneInput // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,otpSentAt: freezed == otpSentAt ? _self.otpSentAt : otpSentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthFlowState].
extension AuthFlowStatePatterns on AuthFlowState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthFlowState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthFlowState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthFlowState value)  $default,){
final _that = this;
switch (_that) {
case _AuthFlowState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthFlowState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthFlowState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthMode mode,  String phoneInput,  String firstName,  String lastName,  bool isSubmitting,  String? phone,  DateTime? otpSentAt,  int? month,  int? day,  int? year)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthFlowState() when $default != null:
return $default(_that.mode,_that.phoneInput,_that.firstName,_that.lastName,_that.isSubmitting,_that.phone,_that.otpSentAt,_that.month,_that.day,_that.year);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthMode mode,  String phoneInput,  String firstName,  String lastName,  bool isSubmitting,  String? phone,  DateTime? otpSentAt,  int? month,  int? day,  int? year)  $default,) {final _that = this;
switch (_that) {
case _AuthFlowState():
return $default(_that.mode,_that.phoneInput,_that.firstName,_that.lastName,_that.isSubmitting,_that.phone,_that.otpSentAt,_that.month,_that.day,_that.year);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthMode mode,  String phoneInput,  String firstName,  String lastName,  bool isSubmitting,  String? phone,  DateTime? otpSentAt,  int? month,  int? day,  int? year)?  $default,) {final _that = this;
switch (_that) {
case _AuthFlowState() when $default != null:
return $default(_that.mode,_that.phoneInput,_that.firstName,_that.lastName,_that.isSubmitting,_that.phone,_that.otpSentAt,_that.month,_that.day,_that.year);case _:
  return null;

}
}

}

/// @nodoc


class _AuthFlowState implements AuthFlowState {
  const _AuthFlowState({required this.mode, this.phoneInput = '', this.firstName = '', this.lastName = '', this.isSubmitting = false, this.phone, this.otpSentAt, this.month, this.day, this.year});
  

@override final  AuthMode mode;
@override@JsonKey() final  String phoneInput;
@override@JsonKey() final  String firstName;
@override@JsonKey() final  String lastName;
@override@JsonKey() final  bool isSubmitting;
@override final  String? phone;
@override final  DateTime? otpSentAt;
@override final  int? month;
@override final  int? day;
@override final  int? year;

/// Create a copy of AuthFlowState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthFlowStateCopyWith<_AuthFlowState> get copyWith => __$AuthFlowStateCopyWithImpl<_AuthFlowState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthFlowState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.phoneInput, phoneInput) || other.phoneInput == phoneInput)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.otpSentAt, otpSentAt) || other.otpSentAt == otpSentAt)&&(identical(other.month, month) || other.month == month)&&(identical(other.day, day) || other.day == day)&&(identical(other.year, year) || other.year == year));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,phoneInput,firstName,lastName,isSubmitting,phone,otpSentAt,month,day,year);
}

@override
String toString() {
    return 'AuthFlowState(mode: $mode, phoneInput: $phoneInput, firstName: $firstName, lastName: $lastName, isSubmitting: $isSubmitting, phone: $phone, otpSentAt: $otpSentAt, month: $month, day: $day, year: $year)';
}


}

/// @nodoc
abstract mixin class _$AuthFlowStateCopyWith<$Res> implements $AuthFlowStateCopyWith<$Res> {
  factory _$AuthFlowStateCopyWith(_AuthFlowState value, $Res Function(_AuthFlowState) _then) = __$AuthFlowStateCopyWithImpl;
@override @useResult
$Res call({
 AuthMode mode, String phoneInput, String firstName, String lastName, bool isSubmitting, String? phone, DateTime? otpSentAt, int? month, int? day, int? year
});




}
/// @nodoc
class __$AuthFlowStateCopyWithImpl<$Res>
    implements _$AuthFlowStateCopyWith<$Res> {
  __$AuthFlowStateCopyWithImpl(this._self, this._then);

  final _AuthFlowState _self;
  final $Res Function(_AuthFlowState) _then;

/// Create a copy of AuthFlowState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? phoneInput = null,Object? firstName = null,Object? lastName = null,Object? isSubmitting = null,Object? phone = freezed,Object? otpSentAt = freezed,Object? month = freezed,Object? day = freezed,Object? year = freezed,}) {
  return _then(_AuthFlowState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AuthMode,phoneInput: null == phoneInput ? _self.phoneInput : phoneInput // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,otpSentAt: freezed == otpSentAt ? _self.otpSentAt : otpSentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,month: freezed == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
