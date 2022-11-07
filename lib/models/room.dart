import 'package:chat_babakcode/models/user.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'chat.dart';

enum RoomType { pvUser, publicGroup, pvGroup, channel }

@HiveType(typeId: 0)
class Room extends HiveObject {
  @HiveField(0)
  String? id;

  // Hive fields go here
  @HiveField(1)
  String? roomName;

  @HiveField(2)
  DateTime? changeAt;

  @HiveField(3)
  DateTime? createAt;

  @HiveField(4)
  bool? removed;

  @HiveField(5)
  List<RoomMember>? members;

  @HiveField(6)
  RoomType? roomType;

  @HiveField(7)
  Chat? lastChat;

  @HiveField(8)
  String? roomImage;

  @HiveField(9)
  List<Chat>? chatList;

  @HiveField(10)
  RoomPositionIndex? roomPositionIndex;

  bool newRoomToGenerate = false;

  Room(
      {required this.id,
      required this.roomName,
      required this.changeAt,
      required this.createAt,
      required this.removed,
      required this.members,
      required this.roomType,
      required this.lastChat,
      required this.roomImage,
      required this.chatList,
      required this.roomPositionIndex,
      this.newRoomToGenerate = false
      });

  static populateRoomFields(Room room, String myUserId) {
    switch (room.roomType) {
      case RoomType.pvUser:
        User friend = room.members!
            .firstWhere((element) => element.user!.id != myUserId)
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
    return RoomType.pvUser;
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

    return Room(
      id: json['_id'],
      roomName: json['roomName'],
      roomPositionIndex: RoomPositionIndex(json['property']['lastIndex'], json['property']['lastIndex']),
      changeAt: changeAtLocal,
      createAt: createAtLocal,
      removed: json['removed'],
      members: (json['members'] as List)
          .map((member) => RoomMember.fromJson(member))
          .toList(),
      roomType: roomTypeFromText(json['roomType']),
      lastChat:
          json['lastChat'] == null ? null : Chat.fromJson(json['lastChat']),
      roomImage: json['roomImage'],
      chatList: ((json['chatList'] ?? []) as List)
          .map((chat) => Chat.fromJson(chat))
          .toList(),
    );
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

@HiveType(typeId: 0)
class RoomMember extends HiveObject {
  @HiveField(0)
  User? user;

  @HiveField(1)
  String? role;

  @HiveField(2)
  bool? restrictedByAdmin;

  @HiveField(3)
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

class RoomPositionIndex{
  int min,max;
  RoomPositionIndex(this.min, this.max);
}