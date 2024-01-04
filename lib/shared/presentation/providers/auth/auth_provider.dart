import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_provider.g.dart';
part 'auth_provider.freezed.dart';

@freezed
class AuthData with _$AuthData {
  factory AuthData({
    bool? loggedIn
  }) = _AuthData;
}

@riverpod
class Auth extends _$Auth {

  late final SharedPreferences _shared;

  @override
  FutureOr<AuthData> build() async {

    _shared = await SharedPreferences.getInstance();

    return AuthData(loggedIn: _shared.getBool("loggedIn"));
  }

  set loggedIn(bool loggedIn) {
    _shared.setBool('loggedIn', loggedIn).then((value) =>
    state = AsyncData(state.value!.copyWith(loggedIn: loggedIn)));
  }

}