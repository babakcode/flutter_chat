part of 'chat.dart';
class ChatPhotoModel extends Chat {

  Uint8List? fakeFile;
  String? fileUrl;
  String? text;
  ChatPhotoModel(Map json): super(json) {
    if(json.containsKey('fileUrl')){
      fileUrl = json['fileUrl'];
    }
    if(json.containsKey('fakeFile')){
      fakeFile = json['fakeFile'];
    }
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