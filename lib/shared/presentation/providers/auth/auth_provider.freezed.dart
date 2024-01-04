// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AuthData {
  bool? get loggedIn => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthDataCopyWith<AuthData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthDataCopyWith<$Res> {
  factory $AuthDataCopyWith(AuthData value, $Res Function(AuthData) then) =
      _$AuthDataCopyWithImpl<$Res, AuthData>;
  @useResult
  $Res call({bool? loggedIn});
}

/// @nodoc
class _$AuthDataCopyWithImpl<$Res, $Val extends AuthData>
    implements $AuthDataCopyWith<$Res> {
  _$AuthDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loggedIn = freezed,
  }) {
    return _then(_value.copyWith(
      loggedIn: freezed == loggedIn
          ? _value.loggedIn
          : loggedIn // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthDataImplCopyWith<$Res>
    implements $AuthDataCopyWith<$Res> {
  factory _$$AuthDataImplCopyWith(
          _$AuthDataImpl value, $Res Function(_$AuthDataImpl) then) =
      __$$AuthDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool? loggedIn});
}

/// @nodoc
class __$$AuthDataImplCopyWithImpl<$Res>
    extends _$AuthDataCopyWithImpl<$Res, _$AuthDataImpl>
    implements _$$AuthDataImplCopyWith<$Res> {
  __$$AuthDataImplCopyWithImpl(
      _$AuthDataImpl _value, $Res Function(_$AuthDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loggedIn = freezed,
  }) {
    return _then(_$AuthDataImpl(
      loggedIn: freezed == loggedIn
          ? _value.loggedIn
          : loggedIn // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc

class _$AuthDataImpl implements _AuthData {
  _$AuthDataImpl({this.loggedIn});

  @override
  final bool? loggedIn;

  @override
  String toString() {
    return 'AuthData(loggedIn: $loggedIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthDataImpl &&
            (identical(other.loggedIn, loggedIn) ||
                other.loggedIn == loggedIn));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loggedIn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthDataImplCopyWith<_$AuthDataImpl> get copyWith =>
      __$$AuthDataImplCopyWithImpl<_$AuthDataImpl>(this, _$identity);
}

abstract class _AuthData implements AuthData {
  factory _AuthData({final bool? loggedIn}) = _$AuthDataImpl;

  @override
  bool? get loggedIn;
  @override
  @JsonKey(ignore: true)
  _$$AuthDataImplCopyWith<_$AuthDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
