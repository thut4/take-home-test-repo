// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpState {

 DateTime get sentAt; DateTime get now; int get failedAttempts; bool get isVerifying; bool get isResending; OtpFeedback? get feedback;
/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpStateCopyWith<OtpState> get copyWith => _$OtpStateCopyWithImpl<OtpState>(this as OtpState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OtpState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpState&&(identical(other.sentAt, _this.sentAt) || other.sentAt == _this.sentAt)&&(identical(other.now, _this.now) || other.now == _this.now)&&(identical(other.failedAttempts, _this.failedAttempts) || other.failedAttempts == _this.failedAttempts)&&(identical(other.isVerifying, _this.isVerifying) || other.isVerifying == _this.isVerifying)&&(identical(other.isResending, _this.isResending) || other.isResending == _this.isResending)&&(identical(other.feedback, _this.feedback) || other.feedback == _this.feedback));
}


@override
int get hashCode {
  final _this = this as OtpState;
  return Object.hash(runtimeType,_this.sentAt,_this.now,_this.failedAttempts,_this.isVerifying,_this.isResending,_this.feedback);
}

@override
String toString() {
  final _this = this as OtpState;
  return 'OtpState(sentAt: ${_this.sentAt}, now: ${_this.now}, failedAttempts: ${_this.failedAttempts}, isVerifying: ${_this.isVerifying}, isResending: ${_this.isResending}, feedback: ${_this.feedback})';
}


}

/// @nodoc
abstract mixin class $OtpStateCopyWith<$Res>  {
  factory $OtpStateCopyWith(OtpState value, $Res Function(OtpState) _then) = _$OtpStateCopyWithImpl;
@useResult
$Res call({
 DateTime sentAt, DateTime now, int failedAttempts, bool isVerifying, bool isResending, OtpFeedback? feedback
});




}
/// @nodoc
class _$OtpStateCopyWithImpl<$Res>
    implements $OtpStateCopyWith<$Res> {
  _$OtpStateCopyWithImpl(this._self, this._then);

  final OtpState _self;
  final $Res Function(OtpState) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sentAt = null,Object? now = null,Object? failedAttempts = null,Object? isVerifying = null,Object? isResending = null,Object? feedback = freezed,}) {
  return _then(OtpState(
sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,isVerifying: null == isVerifying ? _self.isVerifying : isVerifying // ignore: cast_nullable_to_non_nullable
as bool,isResending: null == isResending ? _self.isResending : isResending // ignore: cast_nullable_to_non_nullable
as bool,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as OtpFeedback?,
  ));
}

}


/// Adds pattern-matching-related methods to [OtpState].
extension OtpStatePatterns on OtpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OtpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OtpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OtpState value)  $default,){
final _that = this;
switch (_that) {
case _OtpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OtpState value)?  $default,){
final _that = this;
switch (_that) {
case _OtpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime sentAt,  DateTime now,  int failedAttempts,  bool isVerifying,  bool isResending,  OtpFeedback? feedback)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that.sentAt,_that.now,_that.failedAttempts,_that.isVerifying,_that.isResending,_that.feedback);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime sentAt,  DateTime now,  int failedAttempts,  bool isVerifying,  bool isResending,  OtpFeedback? feedback)  $default,) {final _that = this;
switch (_that) {
case _OtpState():
return $default(_that.sentAt,_that.now,_that.failedAttempts,_that.isVerifying,_that.isResending,_that.feedback);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime sentAt,  DateTime now,  int failedAttempts,  bool isVerifying,  bool isResending,  OtpFeedback? feedback)?  $default,) {final _that = this;
switch (_that) {
case _OtpState() when $default != null:
return $default(_that.sentAt,_that.now,_that.failedAttempts,_that.isVerifying,_that.isResending,_that.feedback);case _:
  return null;

}
}

}

/// @nodoc


class _OtpState extends OtpState {
  const _OtpState({required this.sentAt, required this.now, this.failedAttempts = 0, this.isVerifying = false, this.isResending = false, this.feedback}): super._();
  

@override final  DateTime sentAt;
@override final  DateTime now;
@override@JsonKey() final  int failedAttempts;
@override@JsonKey() final  bool isVerifying;
@override@JsonKey() final  bool isResending;
@override final  OtpFeedback? feedback;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpStateCopyWith<_OtpState> get copyWith => __$OtpStateCopyWithImpl<_OtpState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpState&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.now, now) || other.now == now)&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts)&&(identical(other.isVerifying, isVerifying) || other.isVerifying == isVerifying)&&(identical(other.isResending, isResending) || other.isResending == isResending)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sentAt,now,failedAttempts,isVerifying,isResending,feedback);
}

@override
String toString() {
    return 'OtpState(sentAt: $sentAt, now: $now, failedAttempts: $failedAttempts, isVerifying: $isVerifying, isResending: $isResending, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class _$OtpStateCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory _$OtpStateCopyWith(_OtpState value, $Res Function(_OtpState) _then) = __$OtpStateCopyWithImpl;
@override @useResult
$Res call({
 DateTime sentAt, DateTime now, int failedAttempts, bool isVerifying, bool isResending, OtpFeedback? feedback
});




}
/// @nodoc
class __$OtpStateCopyWithImpl<$Res>
    implements _$OtpStateCopyWith<$Res> {
  __$OtpStateCopyWithImpl(this._self, this._then);

  final _OtpState _self;
  final $Res Function(_OtpState) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sentAt = null,Object? now = null,Object? failedAttempts = null,Object? isVerifying = null,Object? isResending = null,Object? feedback = freezed,}) {
  return _then(_OtpState(
sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as DateTime,now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,isVerifying: null == isVerifying ? _self.isVerifying : isVerifying // ignore: cast_nullable_to_non_nullable
as bool,isResending: null == isResending ? _self.isResending : isResending // ignore: cast_nullable_to_non_nullable
as bool,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as OtpFeedback?,
  ));
}


}

// dart format on
