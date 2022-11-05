import 'package:shared_preferences/shared_preferences.dart';

class ModelAdmin {
  String? tokenAdmin, globalAdminToken;

  ModelAdmin({required this.tokenAdmin, required this.globalAdminToken});

  static addToSharedPrefs(
      SharedPreferences sharedPreferences, ModelAdmin modelAdmin) {
    sharedPreferences.setString('adminToken', modelAdmin.tokenAdmin!);
    sharedPreferences.setString(
        'globalAdminToken', modelAdmin.globalAdminToken!);
  }

  static ModelAdmin? getModelAdmin(SharedPreferences sharedPreferences) {
    if((sharedPreferences.getBool('isLoggedIn') ?? false) == false && sharedPreferences.containsKey('adminToken')){
      return null;
    }
    return ModelAdmin(
        tokenAdmin: sharedPreferences.getString('adminToken'),
        globalAdminToken: sharedPreferences.getString('globalAdminToken'));
  }
}
