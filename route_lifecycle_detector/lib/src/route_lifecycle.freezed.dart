// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_lifecycle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RouteLifecycle {

/// App is in the foreground.
 bool get isForeground;
/// Create a copy of RouteLifecycle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteLifecycleCopyWith<RouteLifecycle> get copyWith => _$RouteLifecycleCopyWithImpl<RouteLifecycle>(this as RouteLifecycle, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteLifecycle&&(identical(other.isForeground, isForeground) || other.isForeground == isForeground));
}


@override
int get hashCode => Object.hash(runtimeType,isForeground);

@override
String toString() {
  return 'RouteLifecycle(isForeground: $isForeground)';
}


}

/// @nodoc
abstract mixin class $RouteLifecycleCopyWith<$Res>  {
  factory $RouteLifecycleCopyWith(RouteLifecycle value, $Res Function(RouteLifecycle) _then) = _$RouteLifecycleCopyWithImpl;
@useResult
$Res call({
 bool isForeground
});




}
/// @nodoc
class _$RouteLifecycleCopyWithImpl<$Res>
    implements $RouteLifecycleCopyWith<$Res> {
  _$RouteLifecycleCopyWithImpl(this._self, this._then);

  final RouteLifecycle _self;
  final $Res Function(RouteLifecycle) _then;

/// Create a copy of RouteLifecycle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isForeground = null,}) {
  return _then(_self.copyWith(
isForeground: null == isForeground ? _self.isForeground : isForeground // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RouteLifecycle].
extension RouteLifecyclePatterns on RouteLifecycle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RouteLifecycleActive value)?  active,TResult Function( RouteLifecycleBuilding value)?  building,TResult Function( RouteLifecycleDestroyed value)?  destroyed,TResult Function( RouteLifecycleInactive value)?  inactive,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RouteLifecycleActive() when active != null:
return active(_that);case RouteLifecycleBuilding() when building != null:
return building(_that);case RouteLifecycleDestroyed() when destroyed != null:
return destroyed(_that);case RouteLifecycleInactive() when inactive != null:
return inactive(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RouteLifecycleActive value)  active,required TResult Function( RouteLifecycleBuilding value)  building,required TResult Function( RouteLifecycleDestroyed value)  destroyed,required TResult Function( RouteLifecycleInactive value)  inactive,}){
final _that = this;
switch (_that) {
case RouteLifecycleActive():
return active(_that);case RouteLifecycleBuilding():
return building(_that);case RouteLifecycleDestroyed():
return destroyed(_that);case RouteLifecycleInactive():
return inactive(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RouteLifecycleActive value)?  active,TResult? Function( RouteLifecycleBuilding value)?  building,TResult? Function( RouteLifecycleDestroyed value)?  destroyed,TResult? Function( RouteLifecycleInactive value)?  inactive,}){
final _that = this;
switch (_that) {
case RouteLifecycleActive() when active != null:
return active(_that);case RouteLifecycleBuilding() when building != null:
return building(_that);case RouteLifecycleDestroyed() when destroyed != null:
return destroyed(_that);case RouteLifecycleInactive() when inactive != null:
return inactive(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ModalRoute<dynamic> route,  bool isForeground)?  active,TResult Function( bool isForeground)?  building,TResult Function( ModalRoute<dynamic>? route,  bool isForeground)?  destroyed,TResult Function( ModalRoute<dynamic> route,  bool isForeground)?  inactive,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RouteLifecycleActive() when active != null:
return active(_that.route,_that.isForeground);case RouteLifecycleBuilding() when building != null:
return building(_that.isForeground);case RouteLifecycleDestroyed() when destroyed != null:
return destroyed(_that.route,_that.isForeground);case RouteLifecycleInactive() when inactive != null:
return inactive(_that.route,_that.isForeground);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ModalRoute<dynamic> route,  bool isForeground)  active,required TResult Function( bool isForeground)  building,required TResult Function( ModalRoute<dynamic>? route,  bool isForeground)  destroyed,required TResult Function( ModalRoute<dynamic> route,  bool isForeground)  inactive,}) {final _that = this;
switch (_that) {
case RouteLifecycleActive():
return active(_that.route,_that.isForeground);case RouteLifecycleBuilding():
return building(_that.isForeground);case RouteLifecycleDestroyed():
return destroyed(_that.route,_that.isForeground);case RouteLifecycleInactive():
return inactive(_that.route,_that.isForeground);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ModalRoute<dynamic> route,  bool isForeground)?  active,TResult? Function( bool isForeground)?  building,TResult? Function( ModalRoute<dynamic>? route,  bool isForeground)?  destroyed,TResult? Function( ModalRoute<dynamic> route,  bool isForeground)?  inactive,}) {final _that = this;
switch (_that) {
case RouteLifecycleActive() when active != null:
return active(_that.route,_that.isForeground);case RouteLifecycleBuilding() when building != null:
return building(_that.isForeground);case RouteLifecycleDestroyed() when destroyed != null:
return destroyed(_that.route,_that.isForeground);case RouteLifecycleInactive() when inactive != null:
return inactive(_that.route,_that.isForeground);case _:
  return null;

}
}

}

/// @nodoc


class RouteLifecycleActive implements RouteLifecycle {
  const RouteLifecycleActive({required this.route, required this.isForeground});
  

/// Route is at the top of the stack.
 final  ModalRoute<dynamic> route;
/// App is in the foreground.
@override final  bool isForeground;

/// Create a copy of RouteLifecycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteLifecycleActiveCopyWith<RouteLifecycleActive> get copyWith => _$RouteLifecycleActiveCopyWithImpl<RouteLifecycleActive>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteLifecycleActive&&(identical(other.route, route) || other.route == route)&&(identical(other.isForeground, isForeground) || other.isForeground == isForeground));
}


@override
int get hashCode => Object.hash(runtimeType,route,isForeground);

@override
String toString() {
  return 'RouteLifecycle.active(route: $route, isForeground: $isForeground)';
}


}

/// @nodoc
abstract mixin class $RouteLifecycleActiveCopyWith<$Res> implements $RouteLifecycleCopyWith<$Res> {
  factory $RouteLifecycleActiveCopyWith(RouteLifecycleActive value, $Res Function(RouteLifecycleActive) _then) = _$RouteLifecycleActiveCopyWithImpl;
@override @useResult
$Res call({
 ModalRoute<dynamic> route, bool isForeground
});




}
/// @nodoc
class _$RouteLifecycleActiveCopyWithImpl<$Res>
    implements $RouteLifecycleActiveCopyWith<$Res> {
  _$RouteLifecycleActiveCopyWithImpl(this._self, this._then);

  final RouteLifecycleActive _self;
  final $Res Function(RouteLifecycleActive) _then;

/// Create a copy of RouteLifecycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? route = null,Object? isForeground = null,}) {
  return _then(RouteLifecycleActive(
route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as ModalRoute<dynamic>,isForeground: null == isForeground ? _self.isForeground : isForeground // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class RouteLifecycleBuilding implements RouteLifecycle {
  const RouteLifecycleBuilding({required this.isForeground});
  

/// App is in the foreground.
@override final  bool isForeground;

/// Create a copy of RouteLifecycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteLifecycleBuildingCopyWith<RouteLifecycleBuilding> get copyWith => _$RouteLifecycleBuildingCopyWithImpl<RouteLifecycleBuilding>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteLifecycleBuilding&&(identical(other.isForeground, isForeground) || other.isForeground == isForeground));
}


@override
int get hashCode => Object.hash(runtimeType,isForeground);

@override
String toString() {
  return 'RouteLifecycle.building(isForeground: $isForeground)';
}


}

/// @nodoc
abstract mixin class $RouteLifecycleBuildingCopyWith<$Res> implements $RouteLifecycleCopyWith<$Res> {
  factory $RouteLifecycleBuildingCopyWith(RouteLifecycleBuilding value, $Res Function(RouteLifecycleBuilding) _then) = _$RouteLifecycleBuildingCopyWithImpl;
@override @useResult
$Res call({
 bool isForeground
});




}
/// @nodoc
class _$RouteLifecycleBuildingCopyWithImpl<$Res>
    implements $RouteLifecycleBuildingCopyWith<$Res> {
  _$RouteLifecycleBuildingCopyWithImpl(this._self, this._then);

  final RouteLifecycleBuilding _self;
  final $Res Function(RouteLifecycleBuilding) _then;

/// Create a copy of RouteLifecycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isForeground = null,}) {
  return _then(RouteLifecycleBuilding(
isForeground: null == isForeground ? _self.isForeground : isForeground // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class RouteLifecycleDestroyed implements RouteLifecycle {
  const RouteLifecycleDestroyed({required this.route, required this.isForeground});
  

/// Route is at the top of the stack.
 final  ModalRoute<dynamic>? route;
/// App is in the foreground.
@override final  bool isForeground;

/// Create a copy of RouteLifecycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteLifecycleDestroyedCopyWith<RouteLifecycleDestroyed> get copyWith => _$RouteLifecycleDestroyedCopyWithImpl<RouteLifecycleDestroyed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteLifecycleDestroyed&&(identical(other.route, route) || other.route == route)&&(identical(other.isForeground, isForeground) || other.isForeground == isForeground));
}


@override
int get hashCode => Object.hash(runtimeType,route,isForeground);

@override
String toString() {
  return 'RouteLifecycle.destroyed(route: $route, isForeground: $isForeground)';
}


}

/// @nodoc
abstract mixin class $RouteLifecycleDestroyedCopyWith<$Res> implements $RouteLifecycleCopyWith<$Res> {
  factory $RouteLifecycleDestroyedCopyWith(RouteLifecycleDestroyed value, $Res Function(RouteLifecycleDestroyed) _then) = _$RouteLifecycleDestroyedCopyWithImpl;
@override @useResult
$Res call({
 ModalRoute<dynamic>? route, bool isForeground
});




}
/// @nodoc
class _$RouteLifecycleDestroyedCopyWithImpl<$Res>
    implements $RouteLifecycleDestroyedCopyWith<$Res> {
  _$RouteLifecycleDestroyedCopyWithImpl(this._self, this._then);

  final RouteLifecycleDestroyed _self;
  final $Res Function(RouteLifecycleDestroyed) _then;

/// Create a copy of RouteLifecycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? route = freezed,Object? isForeground = null,}) {
  return _then(RouteLifecycleDestroyed(
route: freezed == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as ModalRoute<dynamic>?,isForeground: null == isForeground ? _self.isForeground : isForeground // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class RouteLifecycleInactive implements RouteLifecycle {
  const RouteLifecycleInactive({required this.route, required this.isForeground});
  

/// Route is at the top of the stack.
 final  ModalRoute<dynamic> route;
/// App is in the foreground.
@override final  bool isForeground;

/// Create a copy of RouteLifecycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RouteLifecycleInactiveCopyWith<RouteLifecycleInactive> get copyWith => _$RouteLifecycleInactiveCopyWithImpl<RouteLifecycleInactive>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RouteLifecycleInactive&&(identical(other.route, route) || other.route == route)&&(identical(other.isForeground, isForeground) || other.isForeground == isForeground));
}


@override
int get hashCode => Object.hash(runtimeType,route,isForeground);

@override
String toString() {
  return 'RouteLifecycle.inactive(route: $route, isForeground: $isForeground)';
}


}

/// @nodoc
abstract mixin class $RouteLifecycleInactiveCopyWith<$Res> implements $RouteLifecycleCopyWith<$Res> {
  factory $RouteLifecycleInactiveCopyWith(RouteLifecycleInactive value, $Res Function(RouteLifecycleInactive) _then) = _$RouteLifecycleInactiveCopyWithImpl;
@override @useResult
$Res call({
 ModalRoute<dynamic> route, bool isForeground
});




}
/// @nodoc
class _$RouteLifecycleInactiveCopyWithImpl<$Res>
    implements $RouteLifecycleInactiveCopyWith<$Res> {
  _$RouteLifecycleInactiveCopyWithImpl(this._self, this._then);

  final RouteLifecycleInactive _self;
  final $Res Function(RouteLifecycleInactive) _then;

/// Create a copy of RouteLifecycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? route = null,Object? isForeground = null,}) {
  return _then(RouteLifecycleInactive(
route: null == route ? _self.route : route // ignore: cast_nullable_to_non_nullable
as ModalRoute<dynamic>,isForeground: null == isForeground ? _self.isForeground : isForeground // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
