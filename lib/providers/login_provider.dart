import 'dart:convert';
import 'dart:io';
import 'package:chat_babakcode/main.dart';
import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/services/auth_service.dart';
import 'package:chat_babakcode/ui/pages/home/home_page.dart';
import 'package:chat_babakcode/utils/utils.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginProvider extends ChangeNotifier {
  Auth? auth;
  final AuthServices _authServices = AuthServices();

  static String platform = 'web';

  LoginProvider();

  void initAuth(auth) {
    this.auth = auth;
  }

  TextEditingController nameTextController = TextEditingController();
  TextEditingController recoveryPhraseTextController = TextEditingController();
  bool loading = false;

  void registerNewToken() async {
    if (nameTextController.text.isEmpty || tokenDigit == null) {
      Utils.showSnack(navigatorKey.currentContext!, 'Name is empty!');
      return;
    }
    loading = true;
    notifyListeners();

    await _authServices
        .registerNewToken(tokenDigit!, nameTextController.text, platform)
        .then((res) async {
      loading = false;
      notifyListeners();
      if (res == null) {
        print('client request error');
        return;
      }
      final body = res.data;
      Utils.showSnack(navigatorKey.currentContext!, body['msg']);

      if (res.statusCode == 201) {
        await auth?.saveUserDetails(
          myUser: body['myUser'],
          accessToken: body['accessToken'],
        );

        // user created successfully
        Navigator.pushAndRemoveUntil(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false);
      }
    });
  }

  recoveryToken() async {
    if (recoveryPhraseTextController.text.isEmpty) {
      Utils.showSnack(
          navigatorKey.currentContext!, 'Recovery phrase is empty!');
      return;
    }
    loading = true;
    notifyListeners();

    await _authServices
        .recoveryToken(recoveryPhraseTextController.text, platform)
        .then((res) async {
      loading = false;
      notifyListeners();
      if (res == null) {
        print('client request error');
        return;
      }
      final body = res.data;
      Utils.showSnack(navigatorKey.currentContext!, body['msg']);

      // print(RequestManager.decryptData(res?.data['text']));
      if (res.statusCode == 200) {
        // user logged in successfully

        await auth?.saveUserDetails(
          myUser: body['myUser'],
          accessToken: body['accessToken'],
        );
        Navigator.pushAndRemoveUntil(
            navigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
            (route) => false);
      }
    });
  }

  bool changeTokensUi = false;
  String? tokenDigit;
  String randomDigits =
      'ff7ae3d3ecce200324c533606438aa5be8597a180c7fc7c42d29651946a61856';

  bool get copied => _copied;
  bool _copied = false;

  generateSha256Token() {
    String now = DateTime.now().toString();
    String randomChar = Utils.generateRandomString(90);
    var bytes = utf8.encode('$now/babak/$randomChar');
    tokenDigit = sha256.convert(bytes).toString();
    changeTokensUi = true;
    _tokensUI();
  }

  _tokensUI() async {
    await Future.delayed(const Duration(milliseconds: 700));
    randomDigits =
        'a5be8597a180c7fc7c42d29651946a61ff7ae3d3ecce200324c533606438a856';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 80));
    randomDigits =
        'a5be8597a180c7fc7c42d2965ff7ae3d3ecce200324c533606438a1946a61856';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 80));
    randomDigits =
        'e12262e9866fafedd7fd9474927e91968513496a35b904015377812a859237bd';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 80));
    randomDigits =
        '200324c533606438aaff7ae3d3ecce5be8597a180c7fc7c42d29651946a61856';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 80));
    randomDigits =
        'c53360ff7ae3d3aa5be8597a180c7fc7cecce200324643842d29651946a61856';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 80));
    randomDigits =
        '36fafedd7fde12e98668513492266a35b9040159474927e91977812a859237bd';
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 80));
    randomDigits =
        '597a180cf24c533606438aa5be87fc7c42f7ae3d3ecce2003d29651946a61856';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 80));
    randomDigits =
        '200324ff7ae3d3ecc180c7fc7c42d29651946a6185ec533606438aa5be8597a6';
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 80));
    randomDigits =
        '35b9040153e122613496a6fafedd7fd2e9866859474927e91977812a859237bd';
    notifyListeners();
    randomDigits = tokenDigit!;
    notifyListeners();
  }

  void copyToken() async {
    _copied = true;
    notifyListeners();
    await Clipboard.setData(ClipboardData(text: tokenDigit));

    await Future.delayed(const Duration(seconds: 3));
    _copied = false;
    notifyListeners();
  }
}
