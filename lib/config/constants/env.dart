import 'package:flutter_chat/main/app/app_env.dart';

sealed class Env {
  static init(AppEnvironment environment) => _environment = environment;

  static AppEnvironment _environment = AppEnvironment.dev;

  static String get envName => _environment.env.envName;

  static String get baseApi => _environment.env.baseApi;

}