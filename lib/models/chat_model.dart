import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import '/models/model_user.dart';

abstract class ChatModel {
  String? id;
  DateTime? date;
  ModelUser? user;

  static ChatModel detectChatModelType(Map chat) {
    switch (chat['type']) {
      case 'TEXT':
        return ChatTextModel(chat);
      case 'STICKER':
        return ChatStickerModel(chat);
      case 'IMAGE':
        return ChatImageModel(chat);
      case 'VOICE':
        return ChatVoiceModel(chat);
      case 'FILE':
        return ChatFileFormModel(chat);
      default:
        return ChatUpdateRequireModel(chat);
    }
  }

  ChatModel({required Map json}) {
    id = json['_id'];
    if(json['userId'] is String){
      json['userId'] = jsonDecode(json['userId']);
    }
    user = ModelUser.fromData(json['userId']);

    DateTime dateT = DateTime.parse(json['date']);
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateT.toString(), true);
    date = dateTime.toLocal();
  }
}

class ChatUpdateRequireModel extends ChatModel {
  ChatUpdateRequireModel(Map json) : super(json: json);
}

class ChatTextModel extends ChatModel {
  String? text;

  ChatTextModel(Map json) : super(json: json) {
    text = json['message'];
  }
}

//
class ChatImageModel extends ChatModel {
  String? imageUrl;

  ChatImageModel(Map json)
      : super(json: json){
    imageUrl = json['message'];
  }

}

//
class ChatStickerModel extends ChatModel {
  int? stickerId;

  ChatStickerModel(Map json)
      : super(json: json){
    stickerId = int.tryParse(json['message']) ?? 0;
  }

}

//
class ChatVoiceModel extends ChatModel {
  String? fileUrl;
  double? downloadProgress;
  bool isPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();

  ChatVoiceModel(Map json)
      : super(json: json){
    fileUrl = json['message'];
  }

}

class ChatFileFormModel extends ChatModel {
  double? downloadProgress;
  String? fileUrl;

  ChatFileFormModel( Map json)
      : super(json: json){
    fileUrl = json['message'];
  }

}
