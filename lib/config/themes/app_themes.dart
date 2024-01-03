import 'package:flutter/material.dart';
import 'package:flutter_chat/config/constants/constants.dart';

class AppThemes {
  AppThemes._();

  static ThemeData theme(ColorSeed? seed) => ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: seed?.color ?? Colors.blue),
        useMaterial3: true,
      );

  static ThemeData darkTheme(ColorSeed? seed) => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
          seedColor: seed?.color ?? Colors.blue, brightness: Brightness.dark));

  static ThemeMode themeMode(bool? darkMode) => darkMode == true
      ? ThemeMode.dark
      : darkMode == false
          ? ThemeMode.light
          : ThemeMode.system;

  static Widget textScaleBuilder(
          BuildContext context, Widget? child) =>
      MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1)),
          child: child!);

  static ColorSeed colorSeed(String? seed) => ColorSeed.values.firstWhere(
        (element) => element.label == seed,
        orElse: () => ColorSeed.blue,
      );
}
