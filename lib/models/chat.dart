import 'package:intl/intl.dart';
import 'app_collection.dart';
import 'user.dart';

class Chat extends AppCollections {
  String? id;
  User? user;
  String? room;
  String? text;
  String? fileUrl;
  DateTime? utcDate;
  ChatType? type;
  bool? edited;
  bool? deleted;
  Chat? replyId;
  int? chatNumberId;
  int? version;

  Chat();

  static ChatType chatTypeFromText(String type) {
    switch (type) {
      case 'text':
        return ChatType.text;
      case 'sticker':
        return ChatType.sticker;
      case 'video':
        return ChatType.video;
      case 'gif':
        return ChatType.gif;
      case 'voice':
        return ChatType.voice;
      case 'account':
        return ChatType.account;
      case 'action':
        return ChatType.action;
      case 'doc':
        return ChatType.doc;
      case 'photo':
        return ChatType.photo;
      default:
        return ChatType.updateRequired;
    }
  }

  static String chatTypeToString(ChatType type) {
    switch (type) {
      case ChatType.text:
        return 'text';
      case ChatType.sticker:
        return 'sticker';
      case ChatType.video:
        return 'video';
      case ChatType.gif:
        return 'gif';
      case ChatType.voice:
        return 'voice';
      case ChatType.account:
        return 'account';
      case ChatType.action:
        return 'action';
      case ChatType.doc:
        return 'doc';
      case ChatType.photo:
        return 'photo';
      default:
        return 'updateRequired';
    }
  }

  static List<Chat> getChatsFromJsonList(List jsonList) {
    return jsonList.map((e) => Chat.fromJson(e)).toList();
  }

  factory Chat.fromJson(Map json) {
    DateTime utcDateUtc = DateTime.parse(json['utcDate']);
    var utcDateLocal = DateFormat("yyyy-MM-dd HH:mm:ss")
        .parse(utcDateUtc.toString(), true)
        .toLocal();

    return Chat()
      ..id = json['_id']
      ..chatNumberId = json['id']
      ..user = User.fromJson(json['user'])
      ..room = json['room']
      ..text = json['text']
      ..deleted = json['deleted']
      ..fileUrl = json['fileUrl']
      ..utcDate = utcDateLocal
      ..type = chatTypeFromText(json['type'])
      ..edited = json['edited']
      ..replyId =
          json['replyId'] == null ? null : Chat.fromJson(json['replayId'])
      ..version = json['__v'];
  }

  @override
  Map<String, dynamic> toSaveFormat() {
    return {
      '_id': id,
      'id': chatNumberId,
      'user': user,
      'room': room,
      'text': text,
      'fileUrl': fileUrl,
      'utcDate': utcDate.toString(),
      'type': chatTypeToString(type!),
      'edited': edited,
      'deleted': deleted,
      'replyId': replyId,
      '__v': version,
    };
  }
}

enum ChatType {
  text,
  sticker,
  video,
  gif,
  voice,
  account,
  doc,
  photo,
  updateRequired,
  action
}
