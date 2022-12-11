import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_babakcode/main.dart';
import 'package:chat_babakcode/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../models/room.dart';
import 'chat_provider.dart';

class ProfileProvider extends ChangeNotifier {
  ChatProvider? chatProvider;
  TextEditingController contentController = TextEditingController();

  initChatProvider(ChatProvider chatProvider) =>
      this.chatProvider = chatProvider;

  updateUserInfo({required String type, required String content}) {
    if (type == 'name' && content.trim().isEmpty) {
      Utils.showSnack(navigatorKey.currentContext!, 'name is empty');
      return;
    }
    var body = {'type': type, 'content': content};
    chatProvider?.socket.emitWithAck(
      'updateProfile',
      jsonEncode(body),
      ack: (data) async {
        try {
          data = jsonDecode(data);
          if (data['success'] == true) {
            if (type == 'name') {
              await chatProvider?.auth?.changeName(content);
            }

            if (type == 'username') {
              await chatProvider?.auth?.changeUsername(content);
            }
            Navigator.pop(navigatorKey.currentContext!);
          }
          Utils.showSnack(navigatorKey.currentContext!, data['msg']);

        } catch (e) {
          if (kDebugMode) {
            print('exception #003 $e');
          }
        }
      },
    );
  }

  Future updateProfileImage(file) async {
    String fileName = '';
    Uint8List? uint8list;
    if (file is PlatformFile) {
      fileName = file.name;
      if (kIsWeb) {
        uint8list = file.bytes;
      } else {
        uint8list = File(file.path!).readAsBytesSync();
      }
    } else if (file is File) {
      uint8list = file.readAsBytesSync();
      fileName = file.path;
    }

    chatProvider?.socket.emitWithAck(
      'updateProfileImage',
      {
        'file': uint8list,
        'name': fileName,
      },
      ack: (data) async {
        try {
          if (data['success'] == true) {
            await chatProvider?.auth?.changeProfileImage(data['url']);
          }
          Utils.showSnack(navigatorKey.currentContext!, data['msg']);
        } catch (e) {
          if (kDebugMode) {
            print('exception #004 $e');
          }
        }
      },
    );
  }



}
