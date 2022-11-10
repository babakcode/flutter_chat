import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GlobalSettingProvider extends ChangeNotifier {
  Box settingBox = Hive.box('setting');
  GlobalSettingProvider();

  bool get isDarkTheme => settingBox.get('dark') ?? true;
  String get platform => settingBox.get('platform') ?? 'android';

  Future<void> darkTheme(bool dark) async {
    await settingBox.put('dark', dark);
    notifyListeners();
  }

  Future<void> changeThemeToSystem() async {
    await settingBox.delete('dark');
    notifyListeners();
  }

  void toggleThemeMode() =>
      settingBox.put('dark', !isDarkTheme).then((value) => notifyListeners());

  static bool get isPhonePortraitSize => _isPhonePortraitSize;
  static bool _isPhonePortraitSize = true;
  void checkDeviceDetermination(double width) {
    Future.microtask(() {
      if (width > 600) {
        if (_isPhonePortraitSize) {
          print('change to landscape');
          _isPhonePortraitSize = false;
          notifyListeners();
        }
      }else{
        /// width < 500
        if (!_isPhonePortraitSize) {
          print('change to portrait');
          _isPhonePortraitSize = true;
          notifyListeners();
        }
      }
    });
  }
}
