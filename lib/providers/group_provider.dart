import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

import 'chat_provider.dart';

class GroupProvider extends ChangeNotifier {
  PlatformFile? groupImage;
  bool _isPrivate = false;

  set setIsPrivate(bool set){
    _isPrivate = set;
    notifyListeners();
  }

  bool get getIsPrivate => _isPrivate;

  ChatProvider? chatProvider;
  initChatProvider(ChatProvider chatProvider) =>
      this.chatProvider = chatProvider;


  void selectImage() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if(result != null){
      groupImage =  result.files[0];
      notifyListeners();
    }
  }


}