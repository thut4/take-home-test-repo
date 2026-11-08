// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PromoBanner {

 String get id; String get tag; String get title; String get imagePath; BannerStyle get style;
/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromoBannerCopyWith<PromoBanner> get copyWith => _$PromoBannerCopyWithImpl<PromoBanner>(this as PromoBanner, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PromoBanner;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PromoBanner&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.tag, _this.tag) || other.tag == _this.tag)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.imagePath, _this.imagePath) || other.imagePath == _this.imagePath)&&(identical(other.style, _this.style) || other.style == _this.style));
}


@override
int get hashCode {
  final _this = this as PromoBanner;
  return Object.hash(runtimeType,_this.id,_this.tag,_this.title,_this.imagePath,_this.style);
}

@override
String toString() {
  final _this = this as PromoBanner;
  return 'PromoBanner(id: ${_this.id}, tag: ${_this.tag}, title: ${_this.title}, imagePath: ${_this.imagePath}, style: ${_this.style})';
}


}

/// @nodoc
abstract mixin class $PromoBannerCopyWith<$Res>  {
  factory $PromoBannerCopyWith(PromoBanner value, $Res Function(PromoBanner) _then) = _$PromoBannerCopyWithImpl;
@useResult
$Res call({
 String id, String tag, String title, String imagePath, BannerStyle style
});




}
/// @nodoc
class _$PromoBannerCopyWithImpl<$Res>
    implements $PromoBannerCopyWith<$Res> {
  _$PromoBannerCopyWithImpl(this._self, this._then);

  final PromoBanner _self;
  final $Res Function(PromoBanner) _then;

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tag = null,Object? title = null,Object? imagePath = null,Object? style = null,}) {
  return _then(PromoBanner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as BannerStyle,
  ));
}

}


/// Adds pattern-matching-related methods to [PromoBanner].
extension PromoBannerPatterns on PromoBanner {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PromoBanner value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PromoBanner value)  $default,){
final _that = this;
switch (_that) {
case _PromoBanner():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PromoBanner value)?  $default,){
final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tag,  String title,  String imagePath,  BannerStyle style)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
return $default(_that.id,_that.tag,_that.title,_that.imagePath,_that.style);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tag,  String title,  String imagePath,  BannerStyle style)  $default,) {final _that = this;
switch (_that) {
case _PromoBanner():
return $default(_that.id,_that.tag,_that.title,_that.imagePath,_that.style);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tag,  String title,  String imagePath,  BannerStyle style)?  $default,) {final _that = this;
switch (_that) {
case _PromoBanner() when $default != null:
return $default(_that.id,_that.tag,_that.title,_that.imagePath,_that.style);case _:
  return null;

}
}

}

/// @nodoc


class _PromoBanner implements PromoBanner {
  const _PromoBanner({required this.id, required this.tag, required this.title, required this.imagePath, required this.style});
  

@override final  String id;
@override final  String tag;
@override final  String title;
@override final  String imagePath;
@override final  BannerStyle style;

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromoBannerCopyWith<_PromoBanner> get copyWith => __$PromoBannerCopyWithImpl<_PromoBanner>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PromoBanner&&(identical(other.id, id) || other.id == id)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.title, title) || other.title == title)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.style, style) || other.style == style));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,tag,title,imagePath,style);
}

@override
String toString() {
    return 'PromoBanner(id: $id, tag: $tag, title: $title, imagePath: $imagePath, style: $style)';
}


}

/// @nodoc
abstract mixin class _$PromoBannerCopyWith<$Res> implements $PromoBannerCopyWith<$Res> {
  factory _$PromoBannerCopyWith(_PromoBanner value, $Res Function(_PromoBanner) _then) = __$PromoBannerCopyWithImpl;
@override @useResult
$Res call({
 String id, String tag, String title, String imagePath, BannerStyle style
});




}
/// @nodoc
class __$PromoBannerCopyWithImpl<$Res>
    implements _$PromoBannerCopyWith<$Res> {
  __$PromoBannerCopyWithImpl(this._self, this._then);

  final _PromoBanner _self;
  final $Res Function(_PromoBanner) _then;

/// Create a copy of PromoBanner
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tag = null,Object? title = null,Object? imagePath = null,Object? style = null,}) {
  return _then(_PromoBanner(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as BannerStyle,
  ));
}


}

/// @nodoc
mixin _$ProductSection {

 String get id; String get title; SectionLayout get layout; bool get showFlame; List<Product> get products;
/// Create a copy of ProductSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSectionCopyWith<ProductSection> get copyWith => _$ProductSectionCopyWithImpl<ProductSection>(this as ProductSection, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProductSection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSection&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.layout, _this.layout) || other.layout == _this.layout)&&(identical(other.showFlame, _this.showFlame) || other.showFlame == _this.showFlame)&&const DeepCollectionEquality().equals(other.products, _this.products));
}


@override
int get hashCode {
  final _this = this as ProductSection;
  return Object.hash(runtimeType,_this.id,_this.title,_this.layout,_this.showFlame,const DeepCollectionEquality().hash(_this.products));
}

@override
String toString() {
  final _this = this as ProductSection;
  return 'ProductSection(id: ${_this.id}, title: ${_this.title}, layout: ${_this.layout}, showFlame: ${_this.showFlame}, products: ${_this.products})';
}


}

/// @nodoc
abstract mixin class $ProductSectionCopyWith<$Res>  {
  factory $ProductSectionCopyWith(ProductSection value, $Res Function(ProductSection) _then) = _$ProductSectionCopyWithImpl;
@useResult
$Res call({
 String id, String title, SectionLayout layout, bool showFlame, List<Product> products
});




}
/// @nodoc
class _$ProductSectionCopyWithImpl<$Res>
    implements $ProductSectionCopyWith<$Res> {
  _$ProductSectionCopyWithImpl(this._self, this._then);

  final ProductSection _self;
  final $Res Function(ProductSection) _then;

/// Create a copy of ProductSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? layout = null,Object? showFlame = null,Object? products = null,}) {
  return _then(ProductSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as SectionLayout,showFlame: null == showFlame ? _self.showFlame : showFlame // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSection].
extension ProductSectionPatterns on ProductSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSection value)  $default,){
final _that = this;
switch (_that) {
case _ProductSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSection value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  SectionLayout layout,  bool showFlame,  List<Product> products)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSection() when $default != null:
return $default(_that.id,_that.title,_that.layout,_that.showFlame,_that.products);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  SectionLayout layout,  bool showFlame,  List<Product> products)  $default,) {final _that = this;
switch (_that) {
case _ProductSection():
return $default(_that.id,_that.title,_that.layout,_that.showFlame,_that.products);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  SectionLayout layout,  bool showFlame,  List<Product> products)?  $default,) {final _that = this;
switch (_that) {
case _ProductSection() when $default != null:
return $default(_that.id,_that.title,_that.layout,_that.showFlame,_that.products);case _:
  return null;

}
}

}

/// @nodoc


class _ProductSection implements ProductSection {
  const _ProductSection({required this.id, required this.title, required this.layout, required this.showFlame, required  List<Product> products}): _products = products;
  

@override final  String id;
@override final  String title;
@override final  SectionLayout layout;
@override final  bool showFlame;
 final  List<Product> _products;
@override List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of ProductSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSectionCopyWith<_ProductSection> get copyWith => __$ProductSectionCopyWithImpl<_ProductSection>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSection&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.showFlame, showFlame) || other.showFlame == showFlame)&&const DeepCollectionEquality().equals(other.products, _products));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,layout,showFlame,const DeepCollectionEquality().hash(_products));
}

@override
String toString() {
    return 'ProductSection(id: $id, title: $title, layout: $layout, showFlame: $showFlame, products: $products)';
}


}

/// @nodoc
abstract mixin class _$ProductSectionCopyWith<$Res> implements $ProductSectionCopyWith<$Res> {
  factory _$ProductSectionCopyWith(_ProductSection value, $Res Function(_ProductSection) _then) = __$ProductSectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, SectionLayout layout, bool showFlame, List<Product> products
});




}
/// @nodoc
class __$ProductSectionCopyWithImpl<$Res>
    implements _$ProductSectionCopyWith<$Res> {
  __$ProductSectionCopyWithImpl(this._self, this._then);

  final _ProductSection _self;
  final $Res Function(_ProductSection) _then;

/// Create a copy of ProductSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? layout = null,Object? showFlame = null,Object? products = null,}) {
  return _then(_ProductSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as SectionLayout,showFlame: null == showFlame ? _self.showFlame : showFlame // ignore: cast_nullable_to_non_nullable
as bool,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}


}

/// @nodoc
mixin _$Shop {

 String get id; String get name; String get address; String get imagePath;
/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopCopyWith<Shop> get copyWith => _$ShopCopyWithImpl<Shop>(this as Shop, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Shop;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Shop&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.imagePath, _this.imagePath) || other.imagePath == _this.imagePath));
}


@override
int get hashCode {
  final _this = this as Shop;
  return Object.hash(runtimeType,_this.id,_this.name,_this.address,_this.imagePath);
}

@override
String toString() {
  final _this = this as Shop;
  return 'Shop(id: ${_this.id}, name: ${_this.name}, address: ${_this.address}, imagePath: ${_this.imagePath})';
}


}

/// @nodoc
abstract mixin class $ShopCopyWith<$Res>  {
  factory $ShopCopyWith(Shop value, $Res Function(Shop) _then) = _$ShopCopyWithImpl;
@useResult
$Res call({
 String id, String name, String address, String imagePath
});




}
/// @nodoc
class _$ShopCopyWithImpl<$Res>
    implements $ShopCopyWith<$Res> {
  _$ShopCopyWithImpl(this._self, this._then);

  final Shop _self;
  final $Res Function(Shop) _then;

/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = null,Object? imagePath = null,}) {
  return _then(Shop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Shop].
extension ShopPatterns on Shop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Shop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Shop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Shop value)  $default,){
final _that = this;
switch (_that) {
case _Shop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Shop value)?  $default,){
final _that = this;
switch (_that) {
case _Shop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String address,  String imagePath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Shop() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.imagePath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String address,  String imagePath)  $default,) {final _that = this;
switch (_that) {
case _Shop():
return $default(_that.id,_that.name,_that.address,_that.imagePath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String address,  String imagePath)?  $default,) {final _that = this;
switch (_that) {
case _Shop() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.imagePath);case _:
  return null;

}
}

}

/// @nodoc


class _Shop implements Shop {
  const _Shop({required this.id, required this.name, required this.address, required this.imagePath});
  

@override final  String id;
@override final  String name;
@override final  String address;
@override final  String imagePath;

/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopCopyWith<_Shop> get copyWith => __$ShopCopyWithImpl<_Shop>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Shop&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,address,imagePath);
}

@override
String toString() {
    return 'Shop(id: $id, name: $name, address: $address, imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class _$ShopCopyWith<$Res> implements $ShopCopyWith<$Res> {
  factory _$ShopCopyWith(_Shop value, $Res Function(_Shop) _then) = __$ShopCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String address, String imagePath
});




}
/// @nodoc
class __$ShopCopyWithImpl<$Res>
    implements _$ShopCopyWith<$Res> {
  __$ShopCopyWithImpl(this._self, this._then);

  final _Shop _self;
  final $Res Function(_Shop) _then;

/// Create a copy of Shop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = null,Object? imagePath = null,}) {
  return _then(_Shop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,imagePath: null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
