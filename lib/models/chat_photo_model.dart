part of 'chat.dart';
class ChatPhotoModel extends Chat {
  late String fileUrl;
  String? text;
  ChatPhotoModel(Map json): super(json) {
    fileUrl = json['fileUrl'];
    text = json['text'];
  }
  @override
  Map<String, dynamic> toSaveFormat() {
    Map<String, dynamic> _chatSaveFormat = super.toSaveFormat();
    _chatSaveFormat['fileUrl'] = fileUrl;
    _chatSaveFormat['text'] = text;
    _chatSaveFormat['type'] = 'photo';
    return _chatSaveFormat;
  }
}