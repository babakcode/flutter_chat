import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_setting_provider.g.dart';

part 'app_setting_provider.freezed.dart';

@freezed
class AppSettingState with _$AppSettingState {
  factory AppSettingState({
    bool? darkMode,
    String? colorSeed,
  }) = _AppSettingState;
}

@riverpod
class AppSettingAsync extends _$AppSettingAsync {
  /// store app setting in the [_sharedPreferences]
  late SharedPreferences _sharedPreferences;

  @override
  FutureOr<AppSettingState> build() async {
    /// init shared preferences
    _sharedPreferences = await SharedPreferences.getInstance();

    /// init state variables
    return AppSettingState(
      colorSeed: _sharedPreferences.getString('colorSeed'),
      darkMode: _sharedPreferences.getBool('darkMode'),
    );
  }

  set colorSeed(String seed) {
    _sharedPreferences.setString('colorSeed', seed).then(
        (value) => state = AsyncData(state.value!.copyWith(colorSeed: seed)));
  }

  set darkMode(bool darkMode) {
    _sharedPreferences.setBool('darkMode', darkMode).then((value) =>
        state = AsyncData(state.value!.copyWith(darkMode: darkMode)));
  }

  void removeThemeMode() => _sharedPreferences.remove('darkMode').then(
      (value) => state = AsyncData(state.value!.copyWith(darkMode: null)));
}
