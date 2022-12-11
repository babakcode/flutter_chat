import 'dart:convert';
import 'package:chat_babakcode/main.dart';
import 'package:chat_babakcode/models/user.dart';
import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/ui/pages/splash/splash_page.dart';
import 'package:chat_babakcode/utils/crypto_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class Auth extends ChangeNotifier {
  final me = Hive.box('me');

  final CryptoManager _cryptoManager = CryptoManager();

  String? get lastGroupLoadedDate => me.get('lastGroupLoadedDate');

  bool get loggedIn => me.get('loggedIn') ?? false;

  String? get accessToken => _cryptoManager.decryptData(me.get('accessToken'));

  User? get myUser => me.get('myUser') == null ? null : User.fromJson(jsonDecode(_cryptoManager.decryptData(me.get('myUser')) ?? ''));
  String? get myUserString => _cryptoManager.decryptData(me.get('myUser'));

  Future<void> saveUserDetails(
      {required Map myUser, required Map accessToken}) async {
    // await me.put('recoveryPhrase', jsonEncode(recoveryPhrase));
    await me.put('accessToken', accessToken);
    await me.put('myUser', myUser);
    await me.put('loggedIn', true);
  }

  Future<void> logOut() async {
    await me.clear();
    final _chatProvider = navigatorKey.currentContext?.read<ChatProvider>();
    await _chatProvider?.clearDatabase();
    _chatProvider?.rooms = [];
    _chatProvider?.selectedRoom = null;

    Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => const SplashPage()),
        (route) => false);
  }

  Future<void> setLastGroupLoadedDate(String set) async =>
      await me.put('lastGroupLoadedDate', set);

  Future<void> changeName(String content) async{
    User myUser = this.myUser!;
    myUser.name = content;
    final newMyUser = _cryptoManager.encryptData(jsonEncode(myUser.toSaveFormat()));
    await me.put('myUser', newMyUser!.toMap()
    );
    notifyListeners();
  }

  Future<void> changeUsername(String content) async{
    User myUser = this.myUser!;
    myUser.username = content;
    final newMyUser = _cryptoManager.encryptData(jsonEncode(myUser.toSaveFormat()));
    await me.put('myUser', newMyUser!.toMap()
    );

    notifyListeners();
  }

  Future<void> changeProfileImage(String content) async{
    User myUser = this.myUser!;

    myUser.profileUrl = content;
    final newMyUser = _cryptoManager.encryptData(jsonEncode(myUser.toSaveFormat()));
    await me.put('myUser', newMyUser!.toMap()
    );

    notifyListeners();
  }
}
