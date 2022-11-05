import 'package:chat_babakcode/main.dart';
import 'package:flutter/material.dart';
  import 'dart:math';

import 'package:flutter/services.dart';

class Utils {

  static void showSnack(BuildContext context , text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

static String generateRandomString(int len) {
  var r = Random();
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}
static Future<void> coptText(String text, {bool showSnackBar = true}) async {
    await Clipboard.setData(ClipboardData(text: text));
    if(showSnackBar){
      showSnack(navigatorKey.currentContext!, 'copied!');
    }
}

}