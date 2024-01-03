import 'package:flutter/material.dart';
import 'package:flutter_chat/config/routes/routes.dart';
import 'package:flutter_chat/config/themes/app_themes.dart';
import 'package:flutter_chat/shared/presentation/providers/app_settings_provider/app_setting_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nil/nil.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// app setting provider
    final setting = ref.watch(appSettingAsyncProvider);

    return setting.when(
      data: (data) => MaterialApp.router(
        routeInformationProvider: router.routeInformationProvider,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        title: 'Business Chat',
        themeMode: AppThemes.themeMode(data.darkMode),
        darkTheme: AppThemes.darkTheme(AppThemes.colorSeed(data.colorSeed)),
        theme: AppThemes.theme(AppThemes.colorSeed(data.colorSeed)),
        builder: AppThemes.textScaleBuilder,
      ),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
      loading: () => nil,
    );
  }
}