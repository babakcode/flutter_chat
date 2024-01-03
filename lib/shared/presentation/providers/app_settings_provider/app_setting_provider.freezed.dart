// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_setting_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppSettingState {
  bool? get darkMode => throw _privateConstructorUsedError;
  String? get colorSeed => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppSettingStateCopyWith<AppSettingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingStateCopyWith<$Res> {
  factory $AppSettingStateCopyWith(
          AppSettingState value, $Res Function(AppSettingState) then) =
      _$AppSettingStateCopyWithImpl<$Res, AppSettingState>;
  @useResult
  $Res call({bool? darkMode, String? colorSeed});
}

/// @nodoc
class _$AppSettingStateCopyWithImpl<$Res, $Val extends AppSettingState>
    implements $AppSettingStateCopyWith<$Res> {
  _$AppSettingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? darkMode = freezed,
    Object? colorSeed = freezed,
  }) {
    return _then(_value.copyWith(
      darkMode: freezed == darkMode
          ? _value.darkMode
          : darkMode // ignore: cast_nullable_to_non_nullable
              as bool?,
      colorSeed: freezed == colorSeed
          ? _value.colorSeed
          : colorSeed // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppSettingStateImplCopyWith<$Res>
    implements $AppSettingStateCopyWith<$Res> {
  factory _$$AppSettingStateImplCopyWith(_$AppSettingStateImpl value,
          $Res Function(_$AppSettingStateImpl) then) =
      __$$AppSettingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool? darkMode, String? colorSeed});
}

/// @nodoc
class __$$AppSettingStateImplCopyWithImpl<$Res>
    extends _$AppSettingStateCopyWithImpl<$Res, _$AppSettingStateImpl>
    implements _$$AppSettingStateImplCopyWith<$Res> {
  __$$AppSettingStateImplCopyWithImpl(
      _$AppSettingStateImpl _value, $Res Function(_$AppSettingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? darkMode = freezed,
    Object? colorSeed = freezed,
  }) {
    return _then(_$AppSettingStateImpl(
      darkMode: freezed == darkMode
          ? _value.darkMode
          : darkMode // ignore: cast_nullable_to_non_nullable
              as bool?,
      colorSeed: freezed == colorSeed
          ? _value.colorSeed
          : colorSeed // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AppSettingStateImpl implements _AppSettingState {
  _$AppSettingStateImpl({this.darkMode, this.colorSeed});

  @override
  final bool? darkMode;
  @override
  final String? colorSeed;

  @override
  String toString() {
    return 'AppSettingState(darkMode: $darkMode, colorSeed: $colorSeed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingStateImpl &&
            (identical(other.darkMode, darkMode) ||
                other.darkMode == darkMode) &&
            (identical(other.colorSeed, colorSeed) ||
                other.colorSeed == colorSeed));
  }

  @override
  int get hashCode => Object.hash(runtimeType, darkMode, colorSeed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingStateImplCopyWith<_$AppSettingStateImpl> get copyWith =>
      __$$AppSettingStateImplCopyWithImpl<_$AppSettingStateImpl>(
          this, _$identity);
}

abstract class _AppSettingState implements AppSettingState {
  factory _AppSettingState({final bool? darkMode, final String? colorSeed}) =
      _$AppSettingStateImpl;

  @override
  bool? get darkMode;
  @override
  String? get colorSeed;
  @override
  @JsonKey(ignore: true)
  _$$AppSettingStateImplCopyWith<_$AppSettingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
