part of 'chat.dart';

class ChatActionModel extends Chat{
  String? actionText;

  ChatActionModel(Map json): super(json) {
    actionText = json['text'];
  }

  @override
  Map<String, dynamic> toSaveFormat() {
    Map<String, dynamic> _chatSaveFormat = super.toSaveFormat();
    _chatSaveFormat['text'] = actionText;
    _chatSaveFormat['type'] = 'action';
    return _chatSaveFormat;
  }
}