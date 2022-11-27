import 'package:intl/intl.dart';
import 'app_collection.dart';
import 'user.dart';

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

  static Chat detectChatModelType(Map chat) {
    switch (chat['type']) {
      case 'text':
        return ChatTextModel(chat);
      case 'sticker':
        return ChatStickerModel(chat);
      case 'image':
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
  //
  // static ChatType chatTypeFromText(String type) {
  //   switch (type) {
  //     case 'text':
  //       return ChatType.text;
  //     case 'sticker':
  //       return ChatType.sticker;
  //     case 'video':
  //       return ChatType.video;
  //     case 'gif':
  //       return ChatType.gif;
  //     case 'voice':
  //       return ChatType.voice;
  //     case 'account':
  //       return ChatType.account;
  //     case 'action':
  //       return ChatType.action;
  //     case 'doc':
  //       return ChatType.doc;
  //     case 'photo':
  //       return ChatType.photo;
  //     default:
  //       return ChatType.updateRequired;
  //   }
  // }
  //
  // static String chatTypeToString(ChatType type) {
  //   switch (type) {
  //     case ChatType.text:
  //       return 'text';
  //     case ChatType.sticker:
  //       return 'sticker';
  //     case ChatType.video:
  //       return 'video';
  //     case ChatType.gif:
  //       return 'gif';
  //     case ChatType.voice:
  //       return 'voice';
  //     case ChatType.account:
  //       return 'account';
  //     case ChatType.action:
  //       return 'action';
  //     case ChatType.doc:
  //       return 'doc';
  //     case ChatType.photo:
  //       return 'photo';
  //     default:
  //       return 'updateRequired';
  //   }
  // }

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
      // 'text': text,
      // 'fileUrl': fileUrl,
      'utcDate': utcDate.toString(),
      // 'type': chatTypeToString(type!),
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

class ChatVoiceModel extends Chat {
  ChatVoiceModel(super.json);
}

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

class ChatStickerModel extends Chat{
  ChatStickerModel(Map json): super(json);

}

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