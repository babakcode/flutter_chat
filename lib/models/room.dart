import 'package:chat_babakcode/models/user.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chat.dart';

enum RoomType { pvUser, publicGroup, pvGroup, channel, updateRequired }

class Room  {
  String? id;
  String? roomName;
  DateTime? changeAt;
  DateTime? createAt;
  bool? removed;
  List<RoomMember>? members;
  RoomType? roomType;
  Chat? lastChat;
  String? roomImage;
  List<Chat> chatList = [];
  int? lastIndex;

  bool newRoomToGenerate = false;
  bool firstOpen = true;

  Room(
      // {required this.id,
      // required this.roomName,
      // required this.changeAt,
      // required this.createAt,
      // required this.removed,
      // required this.members,
      // required this.roomType,
      // required this.lastChat,
      // required this.roomImage,
      // required this.chatList,
      // required this.lastIndex,
      // this.newRoomToGenerate = false
      // }
      );

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
      ..roomType = roomTypeFromText(json['roomType'])
      ..lastChat =
          json['lastChat'] == null ? null : Chat.fromJson(json['lastChat'])
      ..roomImage = json['roomImage']
      ..chatList = ((json['chatList'] ?? []) as List)
          .map((chat) => Chat.fromJson(chat))
          .toList();
  }

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
}

class RoomMember {
  User? user;

  String? role;

  bool? restrictedByAdmin;

  bool? leftGroup;

  RoomMember();

  factory RoomMember.fromJson(Map json) {
    return RoomMember()
      ..user = User.fromJson(json['user'])
      ..role = json['role']
      ..restrictedByAdmin = json['restrictedByAdmin']
      ..leftGroup = json['leftGroup'];
  }
}
