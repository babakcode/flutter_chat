import 'dart:convert';

import 'package:chat_babakcode/main.dart';
import 'package:chat_babakcode/utils/utils.dart';
import 'package:flutter/cupertino.dart';

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
      ack: (data) async{
        try{
          data = jsonDecode(data);
          print(data);
          if(data['success'] == true){
            print('////////// $data');
            if (type == 'name') {
              print(content);
              await chatProvider?.auth?.changeName(content);
            }

            if (type == 'username') {
              print(content);
              await chatProvider?.auth?.changeUsername(content);
            }
            Navigator.pop(navigatorKey.currentContext!);
          }
          Utils.showSnack(navigatorKey.currentContext!, data['msg']);
        }catch(e){
          print(e);
        }

      },
    );
  }
}
