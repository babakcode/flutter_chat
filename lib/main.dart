import 'package:flutter/material.dart';
import 'package:flutter_chat/config/constants/env.dart';
import 'package:flutter_chat/main/app/app.dart';
import 'package:flutter_chat/main/app/app_env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => mainCommon(AppEnvironment.dev);

Future<void> mainCommon(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setPrefix('BabakCode');
  Env.init(environment);
  runApp(const ProviderScope(
    child: App(),
  ));
}
