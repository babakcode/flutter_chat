import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../utils/utils.dart';
import 'chat_provider.dart';

class GroupProvider extends ChangeNotifier {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController groupDescriptionController = TextEditingController();
  TextEditingController groupLinkController = TextEditingController();

  PlatformFile? groupImage;
  bool _isPrivate = false;
  String? _privateLink;

  String get privateLink => _privateLink ?? '';
  final _random = Random();

  set setIsPrivate(bool set) {
    _isPrivate = set;
    if (_isPrivate) {
      _privateLink = Utils.generateRandomString(35 + _random.nextInt(64 - 35));
    } else {
      _privateLink = null;
    }
    notifyListeners();
  }

  bool get getIsPrivate => _isPrivate;

  ChatProvider? chatProvider;

  initChatProvider(ChatProvider chatProvider) =>
      this.chatProvider = chatProvider;

  void selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      groupImage = result.files[0];
      notifyListeners();
    }
  }

  void createGroup() {
    String? name = groupNameController.text.trim();
    String? description = groupDescriptionController.text.trim();
    String? link = groupLinkController.text.trim();
    if (name.isEmpty) {
      Utils.showSnack('please enter the name field');
      return;
    } else if (description.isEmpty) {
      Utils.showSnack('please enter the description field');
      return;
    } else if (link.isEmpty && !_isPrivate) {
      Utils.showSnack('please enter the username field');
      return;
    }

    Map data = {
      'name': name,
      'des': description,
      'link': _isPrivate ? privateLink : link,
      'type': _isPrivate ? 'pvGroup' : 'publicGroup'
    };

    if (groupImage != null) {
      data['filename'] = groupImage!.path;
      data['file'] = kIsWeb
          ? groupImage!.bytes
          : File(groupImage!.path!).readAsBytesSync();
    }

    chatProvider?.socket
        .emitWithAck('createConversationRoom', data, ack: (response) {
          print(response);

    });
  }
}
