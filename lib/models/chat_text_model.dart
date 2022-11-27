part of 'chat.dart';
class ChatTextModel extends Chat{

  String? text;

  ChatTextModel(Map json): super(json) {
    text = json['text'];
  }

  @override
  Map<String, dynamic> toSaveFormat() {
    Map<String, dynamic> _chatSaveFormat = super.toSaveFormat();
    _chatSaveFormat['text'] = text;
    _chatSaveFormat['type'] = 'text';
    return _chatSaveFormat;
  }
}