
import 'package:intl/intl.dart';

import 'global_collection.dart';
import 'user.dart';

class Chat extends GlobalCollections {
  String? id;
  User? user;
  String? roomId;
  String? text;
  String? fileUrl;
  DateTime? utcDate;
  ChatType? type;
  bool? edited;
  bool? deleted;
  String? replyId;
  int? chatNumberId;
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

  static List<Chat> getChatsFromJsonList(List jsonList){
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
      ..roomId = json['room']
      ..text = json['text']
      ..fileUrl = json['removed']
      ..utcDate = utcDateLocal
      ..type = chatTypeFromText(json['type'])
      ..edited = json['edited']
      ..replyId = json['replyId'];
  }

  @override
  Map<String, dynamic> toSaveFormat() {
    return {
      '_id': id,
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
