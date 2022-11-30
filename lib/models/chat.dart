import 'package:intl/intl.dart';
import 'app_collection.dart';
import 'package:just_audio/just_audio.dart';
import 'user.dart';
part 'chat_text_model.dart';
part 'chat_photo_model.dart';
part 'chat_voice_model.dart';

abstract class Chat extends AppCollections {
  String? id;
  User? user;
  String? room;
  DateTime? utcDate;
  bool? edited;
  bool? deleted;
  Chat? replyId;
  int? chatNumberId;
  int? version;

  /// unnecessary to save variables
  bool sendSuccessfully = true;

  static Chat detectChatModelType(Map chat) {
    switch (chat['type']) {
      case 'text':
        return ChatTextModel(chat);
      case 'sticker':
        return ChatStickerModel(chat);
      case 'photo':
        return ChatPhotoModel(chat);
      case 'voice':
        return ChatVoiceModel(chat);
      case 'doc':
        return ChatDocModel(chat);
      default:
        return ChatUpdateRequireModel(chat);
    }
  }
  Chat(Map json){

    DateTime utcDateUtc = DateTime.parse(json['utcDate']);
    var utcDateLocal = DateFormat("yyyy-MM-dd HH:mm:ss")
        .parse(utcDateUtc.toString(), true)
        .toLocal();

    id = json['_id'];
    chatNumberId = json['id'];
    user = User.fromJson(json['user']);
    room = json['room'];
    // text = json['text'];
    deleted = json['deleted'];
    // fileUrl = json['fileUrl'];
    utcDate = utcDateLocal;
    // type = chatTypeFromText(json['type']);
    edited = json['edited'];
    replyId =
    json['replyId'] == null ? null : detectChatModelType(json['replayId']);
    version = json['__v'];
  }

  static List<Chat> getChatsFromJsonList(List jsonList) {
    return jsonList.map((e) => Chat.detectChatModelType(e)).toList();
  }

  @override
  Map<String, dynamic> toSaveFormat() {
    return {
      '_id': id,
      'id': chatNumberId,
      'user': user,
      'room': room,
      'utcDate': utcDate?.toUtc().toString(),
      'edited': edited,
      'deleted': deleted,
      'replyId': replyId,
      '__v': version,
    };
  }
}

class ChatUpdateRequireModel extends Chat {
  ChatUpdateRequireModel(super.json);
}

class ChatDocModel extends Chat {
  ChatDocModel(super.json);
}



class ChatStickerModel extends Chat{
  ChatStickerModel(Map json): super(json);
}
