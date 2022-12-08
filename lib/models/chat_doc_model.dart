part of 'chat.dart';

class ChatDocModel extends Chat {

  double? downloadProgress;
  Uint8List? fakeFile;
  String? fileUrl;
  String? text;

  ChatDocModel(Map json): super(json) {
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
    _chatSaveFormat['type'] = 'doc';
    return _chatSaveFormat;
  }
}