import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

import 'chat_provider.dart';

class ChannelProvider extends ChangeNotifier {
  TextEditingController channelNameController = TextEditingController();
  TextEditingController channelDescriptionController = TextEditingController();
  TextEditingController channelLinkController = TextEditingController();
  PlatformFile? channelImage;
  ChatProvider? chatProvider;
  initChatProvider(ChatProvider chatProvider) =>
      this.chatProvider = chatProvider;

  void selectImage() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if(result != null){
      channelImage =  result.files[0];
      notifyListeners();
    }
  }

}