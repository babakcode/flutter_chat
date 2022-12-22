import 'dart:io';
import 'dart:typed_data';

import 'package:chat_babakcode/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'chat_provider.dart';

class ChannelProvider extends ChangeNotifier {
  TextEditingController channelNameController = TextEditingController();
  TextEditingController channelDescriptionController = TextEditingController();
  TextEditingController channelLinkController = TextEditingController();
  PlatformFile? channelImage;
  ChatProvider? chatProvider;

  initChatProvider(ChatProvider chatProvider) =>
      this.chatProvider = chatProvider;

  void selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      channelImage = result.files[0];
      notifyListeners();
    }
  }

  void createChannel() {
    String? name = channelNameController.text.trim();
    String? description = channelDescriptionController.text.trim();
    String? link = channelLinkController.text.trim();
    if (name.isEmpty) {
      Utils.showSnack('please enter the name field');
      return;
    } else if (description.isEmpty) {
      Utils.showSnack('please enter the description field');
      return;
    } else if (link.isEmpty) {
      Utils.showSnack('please enter the username field');
      return;
    }

    Map data = {
      'name': name,
      'des': description,
      'link': link,
      'type': 'channel'
    };

    if (channelImage != null) {
      data['filename'] = channelImage!.path;
      data['file'] = kIsWeb
          ? channelImage!.bytes
          : File(channelImage!.path!).readAsBytesSync();
    }

    chatProvider?.socket
        .emitWithAck('createConversationRoom', data, ack: (response) {
      print(response);

    });
  }
}
