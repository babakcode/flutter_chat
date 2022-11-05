import 'dart:convert';
import 'package:chat_babakcode/main.dart';
import 'package:chat_babakcode/models/user.dart';
import 'package:chat_babakcode/ui/pages/splash/splash_page.dart';
import 'package:chat_babakcode/utils/crypto_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Auth extends ChangeNotifier {

  final me = Hive.box('me');

  final CryptoManager _cryptoManager = CryptoManager();


  bool get loggedIn => me.get('loggedIn') ?? false;
  String? get accessToken => _cryptoManager
      .decryptData(me.get('accessToken') ?? '');

  User? get myUser => User.fromJson(me.get('myUser'));

  Future<void> saveUserDetails(
      {
      required Map myUser,
      required accessToken}) async {
    // await me.put('recoveryPhrase', jsonEncode(recoveryPhrase));
    await me.put('accessToken', accessToken);
    await me.put('myUser', myUser);
    await me.put('loggedIn', true);
  }

  Future<void> logOut() async {
    await me.put('loggedIn', false);
    Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => const SplashPage()),
        (route) => false);
  }
}
