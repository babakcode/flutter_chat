import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'app_collection.dart';
import 'user.dart';

final _chatBox = Hive.box('chat');
class Chat extends AppCollections {
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

  Future<void> save() async {
    await _chatBox.put(id, toSaveFormat());
  }

  User? populateUser(){
    final user = _chatBox.get(id);
    if(user != null){
      return User.fromJson(user);
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> toSaveFormat() async {

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
