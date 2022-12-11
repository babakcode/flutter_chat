import 'dart:math';
import 'package:chat_babakcode/main.dart';
import 'package:chat_babakcode/models/chat.dart';
import 'package:chat_babakcode/ui/widgets/app_button.dart';
import 'package:chat_babakcode/ui/widgets/app_button_transparent.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';

class Utils {
  static void showSnack(BuildContext context, text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  static Widget showWarningDialog(BuildContext context) {
    final auth = context.read<Auth>();
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCircular)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          const AppText(
            'Log out',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          const AppText(
            'Are you sure about logging out?',
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButtonTransparent(
                child: const Text('No'),
                padding: const EdgeInsets.symmetric(horizontal: 40),
                onPressed: () => Navigator.pop(context),
              ),
              AppButton(
                splashColor: Colors.red.shade300,
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.red[900]),
                ),
                color: Colors.red[200],
                elevation: 0,
                onPressed: () => auth.logOut(),
              ),
            ],
          )
        ],
      ),
    );
  }

  static String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  static Future<void> coptText(String text, {bool showSnackBar = true}) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (showSnackBar) {
      showSnack(navigatorKey.currentContext!, 'copied!');
    }
  }

  static String displayLastChat(Chat data) {
    String displayLastChat = '';
    if (data is ChatTextModel) {
      ChatTextModel? chat = data;
      displayLastChat = chat.text ?? '';
    } else if (data is ChatPhotoModel) {
      displayLastChat = 'Photo';
    } else if (data is ChatDocModel) {
      displayLastChat = 'Document';
    } else if (data is ChatVoiceModel) {
      displayLastChat = 'Voice';
    } else if (data is ChatUpdateRequireModel) {
      displayLastChat =
      'this message is not supported on your version of business chat!';
    }
    return displayLastChat;
  }
}
