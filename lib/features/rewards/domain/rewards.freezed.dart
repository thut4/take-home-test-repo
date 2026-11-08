// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rewards.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Challenge {

 String get id; RewardTab get tab; String get title; ChallengeArtwork get artwork; String get imagePath; int get progress; int get goal; int get points;
/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeCopyWith<Challenge> get copyWith => _$ChallengeCopyWithImpl<Challenge>(this as Challenge, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Challenge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Challenge&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.tab, _this.tab) || other.tab == _this.tab)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.artwork, _this.artwork) || other.artwork == _this.artwork)&&(identical(other.imagePath, _this.imagePath) || other.imagePath == _this.imagePath)&&(identical(other.progress, _this.progress) || other.progress == _this.progress)&&(identical(other.goal, _this.goal) || other.goal == _this.goal)&&(identical(other.points, _this.points) || other.points == _this.points));
}


@override
int get hashCode {
  final _this = this as Challenge;
  return Object.hash(runtimeType,_this.id,_this.tab,_this.title,_this.artwork,_this.imagePath,_this.progress,_this.goal,_this.points);
}

@override
String toString() {
  final _this = this as Challenge;
  return 'Challenge(id: ${_this.id}, tab: ${_this.tab}, title: ${_this.title}, artwork: ${_this.artwork}, imagePath: ${_this.imagePath}, progress: ${_this.progress}, goal: ${_this.goal}, points: ${_this.points})';
}


}

/// @nodoc
abstract mixin class $ChallengeCopyWith<$Res>  {
  factory $ChallengeCopyWith(Challenge value, $Res Function(Challenge) _then) = _$ChallengeCopyWithImpl;
@useResult
$Res call({
 String id, RewardTab tab, String title, ChallengeArtwork artwork, String imagePath, int progress, int goal, int points
});




}
/// @nodoc
class _$ChallengeCopyWithImpl<$Res>
    implements $ChallengeCopyWith<$Res> {
  _$ChallengeCopyWithImpl(this._self, this._then);

  final Challenge _self;
  final $Res Function(Challenge) _then;

/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tab = null,Object? title = null,Object? artwork = null,Object? imagePath = null,Object? progress = null,Object? goal = null,Object? points = null,}) {
  return _then(Challenge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as RewardTab,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artwork: null == artwork ? _self.artwork : artwork // ignore: cast_nullable_to_non_nullable
as ChallengeArtwork,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Challenge].
extension ChallengePatterns on Challenge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Challenge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Challenge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Challenge value)  $default,){
final _that = this;
switch (_that) {
case _Challenge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Challenge value)?  $default,){
final _that = this;
switch (_that) {
case _Challenge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  RewardTab tab,  String title,  ChallengeArtwork artwork,  String imagePath,  int progress,  int goal,  int points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Challenge() when $default != null:
return $default(_that.id,_that.tab,_that.title,_that.artwork,_that.imagePath,_that.progress,_that.goal,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  RewardTab tab,  String title,  ChallengeArtwork artwork,  String imagePath,  int progress,  int goal,  int points)  $default,) {final _that = this;
switch (_that) {
case _Challenge():
return $default(_that.id,_that.tab,_that.title,_that.artwork,_that.imagePath,_that.progress,_that.goal,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  RewardTab tab,  String title,  ChallengeArtwork artwork,  String imagePath,  int progress,  int goal,  int points)?  $default,) {final _that = this;
switch (_that) {
case _Challenge() when $default != null:
return $default(_that.id,_that.tab,_that.title,_that.artwork,_that.imagePath,_that.progress,_that.goal,_that.points);case _:
  return null;

}
}

}

/// @nodoc


class _Challenge extends Challenge {
  const _Challenge({required this.id, required this.tab, required this.title, required this.artwork, required this.imagePath, required this.progress, required this.goal, required this.points}): super._();
  

@override final  String id;
@override final  RewardTab tab;
@override final  String title;
@override final  ChallengeArtwork artwork;
@override final  String imagePath;
@override final  int progress;
@override final  int goal;
@override final  int points;

/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengeCopyWith<_Challenge> get copyWith => __$ChallengeCopyWithImpl<_Challenge>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Challenge&&(identical(other.id, id) || other.id == id)&&(identical(other.tab, tab) || other.tab == tab)&&(identical(other.title, title) || other.title == title)&&(identical(other.artwork, artwork) || other.artwork == artwork)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.goal, goal) || other.goal == goal)&&(identical(other.points, points) || other.points == points));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,tab,title,artwork,imagePath,progress,goal,points);
}

@override
String toString() {
    return 'Challenge(id: $id, tab: $tab, title: $title, artwork: $artwork, imagePath: $imagePath, progress: $progress, goal: $goal, points: $points)';
}


}

/// @nodoc
abstract mixin class _$ChallengeCopyWith<$Res> implements $ChallengeCopyWith<$Res> {
  factory _$ChallengeCopyWith(_Challenge value, $Res Function(_Challenge) _then) = __$ChallengeCopyWithImpl;
@override @useResult
$Res call({
 String id, RewardTab tab, String title, ChallengeArtwork artwork, String imagePath, int progress, int goal, int points
});




}
/// @nodoc
class __$ChallengeCopyWithImpl<$Res>
    implements _$ChallengeCopyWith<$Res> {
  __$ChallengeCopyWithImpl(this._self, this._then);

  final _Challenge _self;
  final $Res Function(_Challenge) _then;

/// Create a copy of Challenge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tab = null,Object? title = null,Object? artwork = null,Object? imagePath = null,Object? progress = null,Object? goal = null,Object? points = null,}) {
  return _then(_Challenge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tab: null == tab ? _self.tab : tab // ignore: cast_nullable_to_non_nullable
as RewardTab,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artwork: null == artwork ? _self.artwork : artwork // ignore: cast_nullable_to_non_nullable
as ChallengeArtwork,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,goal: null == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$LadderStep {

 Tier get tier; LadderStatus get status;/// For [LadderStatus.next]: points still needed.
 int get pointsRemaining;
/// Create a copy of LadderStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LadderStepCopyWith<LadderStep> get copyWith => _$LadderStepCopyWithImpl<LadderStep>(this as LadderStep, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LadderStep;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LadderStep&&(identical(other.tier, _this.tier) || other.tier == _this.tier)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.pointsRemaining, _this.pointsRemaining) || other.pointsRemaining == _this.pointsRemaining));
}


@override
int get hashCode {
  final _this = this as LadderStep;
  return Object.hash(runtimeType,_this.tier,_this.status,_this.pointsRemaining);
}

@override
String toString() {
  final _this = this as LadderStep;
  return 'LadderStep(tier: ${_this.tier}, status: ${_this.status}, pointsRemaining: ${_this.pointsRemaining})';
}


}

/// @nodoc
abstract mixin class $LadderStepCopyWith<$Res>  {
  factory $LadderStepCopyWith(LadderStep value, $Res Function(LadderStep) _then) = _$LadderStepCopyWithImpl;
@useResult
$Res call({
 Tier tier, LadderStatus status, int pointsRemaining
});


$TierCopyWith<$Res> get tier;

}
/// @nodoc
class _$LadderStepCopyWithImpl<$Res>
    implements $LadderStepCopyWith<$Res> {
  _$LadderStepCopyWithImpl(this._self, this._then);

  final LadderStep _self;
  final $Res Function(LadderStep) _then;

/// Create a copy of LadderStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tier = null,Object? status = null,Object? pointsRemaining = null,}) {
  return _then(LadderStep(
tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as Tier,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LadderStatus,pointsRemaining: null == pointsRemaining ? _self.pointsRemaining : pointsRemaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of LadderStep
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TierCopyWith<$Res> get tier {
  
  return $TierCopyWith<$Res>(_self.tier, (value) {
    return _then(_self.copyWith(tier: value));
  });
}
}


/// Adds pattern-matching-related methods to [LadderStep].
extension LadderStepPatterns on LadderStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LadderStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LadderStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LadderStep value)  $default,){
final _that = this;
switch (_that) {
case _LadderStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LadderStep value)?  $default,){
final _that = this;
switch (_that) {
case _LadderStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Tier tier,  LadderStatus status,  int pointsRemaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LadderStep() when $default != null:
return $default(_that.tier,_that.status,_that.pointsRemaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Tier tier,  LadderStatus status,  int pointsRemaining)  $default,) {final _that = this;
switch (_that) {
case _LadderStep():
return $default(_that.tier,_that.status,_that.pointsRemaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Tier tier,  LadderStatus status,  int pointsRemaining)?  $default,) {final _that = this;
switch (_that) {
case _LadderStep() when $default != null:
return $default(_that.tier,_that.status,_that.pointsRemaining);case _:
  return null;

}
}

}

/// @nodoc


class _LadderStep implements LadderStep {
  const _LadderStep({required this.tier, required this.status, required this.pointsRemaining});
  

@override final  Tier tier;
@override final  LadderStatus status;
/// For [LadderStatus.next]: points still needed.
@override final  int pointsRemaining;

/// Create a copy of LadderStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LadderStepCopyWith<_LadderStep> get copyWith => __$LadderStepCopyWithImpl<_LadderStep>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LadderStep&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.status, status) || other.status == status)&&(identical(other.pointsRemaining, pointsRemaining) || other.pointsRemaining == pointsRemaining));
}


@override
int get hashCode {
    return Object.hash(runtimeType,tier,status,pointsRemaining);
}

@override
String toString() {
    return 'LadderStep(tier: $tier, status: $status, pointsRemaining: $pointsRemaining)';
}


}

/// @nodoc
abstract mixin class _$LadderStepCopyWith<$Res> implements $LadderStepCopyWith<$Res> {
  factory _$LadderStepCopyWith(_LadderStep value, $Res Function(_LadderStep) _then) = __$LadderStepCopyWithImpl;
@override @useResult
$Res call({
 Tier tier, LadderStatus status, int pointsRemaining
});


@override $TierCopyWith<$Res> get tier;

}
/// @nodoc
class __$LadderStepCopyWithImpl<$Res>
    implements _$LadderStepCopyWith<$Res> {
  __$LadderStepCopyWithImpl(this._self, this._then);

  final _LadderStep _self;
  final $Res Function(_LadderStep) _then;

/// Create a copy of LadderStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tier = null,Object? status = null,Object? pointsRemaining = null,}) {
  return _then(_LadderStep(
tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as Tier,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LadderStatus,pointsRemaining: null == pointsRemaining ? _self.pointsRemaining : pointsRemaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of LadderStep
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TierCopyWith<$Res> get tier {
  
  return $TierCopyWith<$Res>(_self.tier, (value) {
    return _then(_self.copyWith(tier: value));
  });
}
}

// dart format on
