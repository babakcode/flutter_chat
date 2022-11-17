import 'package:chat_babakcode/models/user.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chat.dart';
import 'global_collection.dart';
import 'room_member.dart';

class Room extends GlobalCollections {

  String? id;
  String? roomName;
  DateTime? changeAt;
  DateTime? createAt;
  bool? removed;
  List<RoomMember>? members;
  RoomType? roomType;
  Chat? lastChat;
  String? roomImage;
  SavableList<Chat> chatList = SavableList(collection: 'chat');
  int? lastIndex;
  int minViewPortSeenIndex = 0;

  bool newRoomToGenerate = false;
  bool reachedToEnd = false;


  Room();

  factory Room.fromJson(Map json) {
    DateTime? createAtLocal;
    DateTime? changeAtLocal;
    if(json['createAt'] != null){
      DateTime createAtUtc = DateTime.parse(json['createAt']);
      createAtLocal = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(createAtUtc.toString(), true)
          .toLocal();
    }
    if(json['changeAt'] != null){
      DateTime changeAtUtc = DateTime.parse(json['changeAt']);
      changeAtLocal = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(changeAtUtc.toString(), true)
          .toLocal();
    }


    return Room()
      ..id = json['_id']
      ..roomName = json['roomName']
      ..lastIndex = json['property']['lastIndex']
      ..changeAt = changeAtLocal
      ..createAt = createAtLocal
      ..removed = json['removed']
      ..members = (json['members'] as List)
          .map((member) => RoomMember.fromJson(member))
          .toList()
      ..roomType = _RoomUtils.roomTypeFromText(json['roomType'])
      ..lastChat =
          json['lastChat'] == null ? null : Chat.fromJson(json['lastChat'])
      ..roomImage = json['roomImage']
      // ..chatList.list = ((json['chatList'] ?? []) as List)
      //     .map((chat) => Chat.fromJson(chat))
      //     .toList()
    ;
  }

  @override
  Map<String, dynamic> toSaveFormat() =>{
      '_id': id,
      'roomName': roomName,
      'changeAt': changeAt.toString(),
      'createAt': createAt.toString(),
      'removed': removed,
      'members': members,
      'roomType': _RoomUtils.roomTypeToString(roomType!),
      'lastChat': lastChat?.toSaveFormat(),
      'roomImage': roomImage,
      'lastIndex': lastIndex,
      'minViewPortSeenIndex': minViewPortSeenIndex,
  };

  static populateRoomFields(Room room, User myAccount) => _RoomUtils.populateRoomFields(room, myAccount);
  static generateProfileImageByName(Room room) => _RoomUtils.generateProfileImageByName(room);
}


enum RoomType { pvUser, publicGroup, pvGroup, channel, updateRequired }

class _RoomUtils{

  static List<Room> roomsFromJson(List jsonList) {
    return (jsonList).map((e) => Room.fromJson(e)).toList();
  }
  static Widget generateProfileImageByName(Room room) {
    String name = room.roomName ?? 'guest';
    String family = '';
    if (name.contains(' ')) {
      family = ' ' + name.split(' ')[1][0];
    }

    return Center(child: AppText(name[0] + family));
  }

  static populateRoomFields(Room room, User myAccount) {
    switch (room.roomType) {
      case RoomType.pvUser:

        if(room.members![0].user!.id == myAccount.id && room.members![1].user!.id == myAccount.id){
          room.roomName = 'My Messages';
          room.roomImage = myAccount.profileUrl;
          room.roomType = RoomType.pvUser;
          break;
        }

        User friend = room.members!
            .firstWhere((element) => element.user!.id != myAccount.id)
            .user!;
        room.roomName = friend.name;
        room.roomImage = friend.profileUrl;
        break;
      case RoomType.publicGroup:
      // TODO: Handle this case.
        break;
      case RoomType.pvGroup:
      // TODO: Handle this case.
        break;
      case RoomType.channel:
      // TODO: Handle this case.
        break;
      default:{

      }
    }
  }
  static RoomType roomTypeFromText(String type) {
    switch (type) {
      case 'pvUser':
        return RoomType.pvUser;
      case 'channel':
        return RoomType.channel;
      case 'publicGroup':
        return RoomType.publicGroup;
      case 'pvGroup':
        return RoomType.pvGroup;
    }
    return RoomType.updateRequired;
  }
  static String roomTypeToString(RoomType roomType){

    switch (roomType) {
      case RoomType.pvUser:
        return 'pvUser';
      case RoomType.channel:
        return 'channel';
      case RoomType.publicGroup:
        return 'publicGroup';
      case RoomType.pvGroup:
        return 'pvGroup';
      case RoomType.updateRequired:
      default:
        return 'updateRequired';
    }
  }

}
