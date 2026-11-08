// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Tier {

 String get id; String get name; int get rank; int? get pointsToNext;
/// Create a copy of Tier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TierCopyWith<Tier> get copyWith => _$TierCopyWithImpl<Tier>(this as Tier, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Tier;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tier&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&(identical(other.pointsToNext, _this.pointsToNext) || other.pointsToNext == _this.pointsToNext));
}


@override
int get hashCode {
  final _this = this as Tier;
  return Object.hash(runtimeType,_this.id,_this.name,_this.rank,_this.pointsToNext);
}

@override
String toString() {
  final _this = this as Tier;
  return 'Tier(id: ${_this.id}, name: ${_this.name}, rank: ${_this.rank}, pointsToNext: ${_this.pointsToNext})';
}


}

/// @nodoc
abstract mixin class $TierCopyWith<$Res>  {
  factory $TierCopyWith(Tier value, $Res Function(Tier) _then) = _$TierCopyWithImpl;
@useResult
$Res call({
 String id, String name, int rank, int? pointsToNext
});




}
/// @nodoc
class _$TierCopyWithImpl<$Res>
    implements $TierCopyWith<$Res> {
  _$TierCopyWithImpl(this._self, this._then);

  final Tier _self;
  final $Res Function(Tier) _then;

/// Create a copy of Tier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? rank = null,Object? pointsToNext = freezed,}) {
  return _then(Tier(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,pointsToNext: freezed == pointsToNext ? _self.pointsToNext : pointsToNext // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Tier].
extension TierPatterns on Tier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tier value)  $default,){
final _that = this;
switch (_that) {
case _Tier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tier value)?  $default,){
final _that = this;
switch (_that) {
case _Tier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int rank,  int? pointsToNext)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tier() when $default != null:
return $default(_that.id,_that.name,_that.rank,_that.pointsToNext);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int rank,  int? pointsToNext)  $default,) {final _that = this;
switch (_that) {
case _Tier():
return $default(_that.id,_that.name,_that.rank,_that.pointsToNext);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int rank,  int? pointsToNext)?  $default,) {final _that = this;
switch (_that) {
case _Tier() when $default != null:
return $default(_that.id,_that.name,_that.rank,_that.pointsToNext);case _:
  return null;

}
}

}

/// @nodoc


class _Tier implements Tier {
  const _Tier({required this.id, required this.name, required this.rank, this.pointsToNext});
  

@override final  String id;
@override final  String name;
@override final  int rank;
@override final  int? pointsToNext;

/// Create a copy of Tier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TierCopyWith<_Tier> get copyWith => __$TierCopyWithImpl<_Tier>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.pointsToNext, pointsToNext) || other.pointsToNext == pointsToNext));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,rank,pointsToNext);
}

@override
String toString() {
    return 'Tier(id: $id, name: $name, rank: $rank, pointsToNext: $pointsToNext)';
}


}

/// @nodoc
abstract mixin class _$TierCopyWith<$Res> implements $TierCopyWith<$Res> {
  factory _$TierCopyWith(_Tier value, $Res Function(_Tier) _then) = __$TierCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int rank, int? pointsToNext
});




}
/// @nodoc
class __$TierCopyWithImpl<$Res>
    implements _$TierCopyWith<$Res> {
  __$TierCopyWithImpl(this._self, this._then);

  final _Tier _self;
  final $Res Function(_Tier) _then;

/// Create a copy of Tier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? rank = null,Object? pointsToNext = freezed,}) {
  return _then(_Tier(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,pointsToNext: freezed == pointsToNext ? _self.pointsToNext : pointsToNext // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$Member {

 String get phone; String get firstName; String get photoPath; Tier get tier; int get tierPoints; int get totalPoints; int get notificationCount; int get rewardCount; String? get lastName; Tier? get nextTier;
/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberCopyWith<Member> get copyWith => _$MemberCopyWithImpl<Member>(this as Member, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Member;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Member&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.tier, _this.tier) || other.tier == _this.tier)&&(identical(other.tierPoints, _this.tierPoints) || other.tierPoints == _this.tierPoints)&&(identical(other.totalPoints, _this.totalPoints) || other.totalPoints == _this.totalPoints)&&(identical(other.notificationCount, _this.notificationCount) || other.notificationCount == _this.notificationCount)&&(identical(other.rewardCount, _this.rewardCount) || other.rewardCount == _this.rewardCount)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.nextTier, _this.nextTier) || other.nextTier == _this.nextTier));
}


@override
int get hashCode {
  final _this = this as Member;
  return Object.hash(runtimeType,_this.phone,_this.firstName,_this.photoPath,_this.tier,_this.tierPoints,_this.totalPoints,_this.notificationCount,_this.rewardCount,_this.lastName,_this.nextTier);
}

@override
String toString() {
  final _this = this as Member;
  return 'Member(phone: ${_this.phone}, firstName: ${_this.firstName}, photoPath: ${_this.photoPath}, tier: ${_this.tier}, tierPoints: ${_this.tierPoints}, totalPoints: ${_this.totalPoints}, notificationCount: ${_this.notificationCount}, rewardCount: ${_this.rewardCount}, lastName: ${_this.lastName}, nextTier: ${_this.nextTier})';
}


}

/// @nodoc
abstract mixin class $MemberCopyWith<$Res>  {
  factory $MemberCopyWith(Member value, $Res Function(Member) _then) = _$MemberCopyWithImpl;
@useResult
$Res call({
 String phone, String firstName, String photoPath, Tier tier, int tierPoints, int totalPoints, int notificationCount, int rewardCount, String? lastName, Tier? nextTier
});


$TierCopyWith<$Res> get tier;$TierCopyWith<$Res>? get nextTier;

}
/// @nodoc
class _$MemberCopyWithImpl<$Res>
    implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._self, this._then);

  final Member _self;
  final $Res Function(Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,Object? firstName = null,Object? photoPath = null,Object? tier = null,Object? tierPoints = null,Object? totalPoints = null,Object? notificationCount = null,Object? rewardCount = null,Object? lastName = freezed,Object? nextTier = freezed,}) {
  return _then(Member(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as Tier,tierPoints: null == tierPoints ? _self.tierPoints : tierPoints // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,notificationCount: null == notificationCount ? _self.notificationCount : notificationCount // ignore: cast_nullable_to_non_nullable
as int,rewardCount: null == rewardCount ? _self.rewardCount : rewardCount // ignore: cast_nullable_to_non_nullable
as int,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,nextTier: freezed == nextTier ? _self.nextTier : nextTier // ignore: cast_nullable_to_non_nullable
as Tier?,
  ));
}
/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TierCopyWith<$Res> get tier {
  
  return $TierCopyWith<$Res>(_self.tier, (value) {
    return _then(_self.copyWith(tier: value));
  });
}/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TierCopyWith<$Res>? get nextTier {
    if (_self.nextTier == null) {
    return null;
  }

  return $TierCopyWith<$Res>(_self.nextTier!, (value) {
    return _then(_self.copyWith(nextTier: value));
  });
}
}


/// Adds pattern-matching-related methods to [Member].
extension MemberPatterns on Member {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Member value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Member value)  $default,){
final _that = this;
switch (_that) {
case _Member():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Member value)?  $default,){
final _that = this;
switch (_that) {
case _Member() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phone,  String firstName,  String photoPath,  Tier tier,  int tierPoints,  int totalPoints,  int notificationCount,  int rewardCount,  String? lastName,  Tier? nextTier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.phone,_that.firstName,_that.photoPath,_that.tier,_that.tierPoints,_that.totalPoints,_that.notificationCount,_that.rewardCount,_that.lastName,_that.nextTier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phone,  String firstName,  String photoPath,  Tier tier,  int tierPoints,  int totalPoints,  int notificationCount,  int rewardCount,  String? lastName,  Tier? nextTier)  $default,) {final _that = this;
switch (_that) {
case _Member():
return $default(_that.phone,_that.firstName,_that.photoPath,_that.tier,_that.tierPoints,_that.totalPoints,_that.notificationCount,_that.rewardCount,_that.lastName,_that.nextTier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phone,  String firstName,  String photoPath,  Tier tier,  int tierPoints,  int totalPoints,  int notificationCount,  int rewardCount,  String? lastName,  Tier? nextTier)?  $default,) {final _that = this;
switch (_that) {
case _Member() when $default != null:
return $default(_that.phone,_that.firstName,_that.photoPath,_that.tier,_that.tierPoints,_that.totalPoints,_that.notificationCount,_that.rewardCount,_that.lastName,_that.nextTier);case _:
  return null;

}
}

}

/// @nodoc


class _Member extends Member {
  const _Member({required this.phone, required this.firstName, required this.photoPath, required this.tier, required this.tierPoints, required this.totalPoints, required this.notificationCount, required this.rewardCount, this.lastName, this.nextTier}): super._();
  

@override final  String phone;
@override final  String firstName;
@override final  String photoPath;
@override final  Tier tier;
@override final  int tierPoints;
@override final  int totalPoints;
@override final  int notificationCount;
@override final  int rewardCount;
@override final  String? lastName;
@override final  Tier? nextTier;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberCopyWith<_Member> get copyWith => __$MemberCopyWithImpl<_Member>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Member&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.tierPoints, tierPoints) || other.tierPoints == tierPoints)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.notificationCount, notificationCount) || other.notificationCount == notificationCount)&&(identical(other.rewardCount, rewardCount) || other.rewardCount == rewardCount)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.nextTier, nextTier) || other.nextTier == nextTier));
}


@override
int get hashCode {
    return Object.hash(runtimeType,phone,firstName,photoPath,tier,tierPoints,totalPoints,notificationCount,rewardCount,lastName,nextTier);
}

@override
String toString() {
    return 'Member(phone: $phone, firstName: $firstName, photoPath: $photoPath, tier: $tier, tierPoints: $tierPoints, totalPoints: $totalPoints, notificationCount: $notificationCount, rewardCount: $rewardCount, lastName: $lastName, nextTier: $nextTier)';
}


}

/// @nodoc
abstract mixin class _$MemberCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$MemberCopyWith(_Member value, $Res Function(_Member) _then) = __$MemberCopyWithImpl;
@override @useResult
$Res call({
 String phone, String firstName, String photoPath, Tier tier, int tierPoints, int totalPoints, int notificationCount, int rewardCount, String? lastName, Tier? nextTier
});


@override $TierCopyWith<$Res> get tier;@override $TierCopyWith<$Res>? get nextTier;

}
/// @nodoc
class __$MemberCopyWithImpl<$Res>
    implements _$MemberCopyWith<$Res> {
  __$MemberCopyWithImpl(this._self, this._then);

  final _Member _self;
  final $Res Function(_Member) _then;

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? firstName = null,Object? photoPath = null,Object? tier = null,Object? tierPoints = null,Object? totalPoints = null,Object? notificationCount = null,Object? rewardCount = null,Object? lastName = freezed,Object? nextTier = freezed,}) {
  return _then(_Member(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as Tier,tierPoints: null == tierPoints ? _self.tierPoints : tierPoints // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,notificationCount: null == notificationCount ? _self.notificationCount : notificationCount // ignore: cast_nullable_to_non_nullable
as int,rewardCount: null == rewardCount ? _self.rewardCount : rewardCount // ignore: cast_nullable_to_non_nullable
as int,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,nextTier: freezed == nextTier ? _self.nextTier : nextTier // ignore: cast_nullable_to_non_nullable
as Tier?,
  ));
}

/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TierCopyWith<$Res> get tier {
  
  return $TierCopyWith<$Res>(_self.tier, (value) {
    return _then(_self.copyWith(tier: value));
  });
}/// Create a copy of Member
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TierCopyWith<$Res>? get nextTier {
    if (_self.nextTier == null) {
    return null;
  }

  return $TierCopyWith<$Res>(_self.nextTier!, (value) {
    return _then(_self.copyWith(nextTier: value));
  });
}
}

// dart format on
