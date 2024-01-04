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
  /// store app setting in the [_shared]
  late final SharedPreferences _shared;

  @override
  FutureOr<AppSettingState> build() async {
    /// init shared preferences
    _shared = await SharedPreferences.getInstance();

    /// init state variables
    return AppSettingState(
      colorSeed: _shared.getString('colorSeed'),
      darkMode: _shared.getBool('darkMode'),
    );
  }

  set colorSeed(String seed) {
    _shared.setString('colorSeed', seed).then(
        (value) => state = AsyncData(state.value!.copyWith(colorSeed: seed)));
  }

  set darkMode(bool darkMode) {
    _shared.setBool('darkMode', darkMode).then((value) =>
        state = AsyncData(state.value!.copyWith(darkMode: darkMode)));
  }

  void removeThemeMode() => _shared.remove('darkMode').then(
      (value) => state = AsyncData(state.value!.copyWith(darkMode: null)));
}
