import 'package:chat_babakcode/models/user.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chat.dart';
import 'app_collection.dart';
import 'room_member.dart';

class Room extends AppCollections {
  String? id;
  String? roomName;
  DateTime? changeAt;
  DateTime? createAt;
  bool? deleted;
  String? identifier;
  List<RoomMember>? members = [];
  RoomType? roomType;
  Chat? lastChat;
  String? roomImage;
  List<Chat> chatList = [];
  int? lastIndex;
  late bool canSendChat;
  int? membersLength;
  int minViewPortSeenIndex = 0;
  bool verified = false;

  bool newRoomToGenerate = false;
  bool reachedToEnd = false;
  bool reachedToStart = false;
  bool firstOpenRoom = true;
  bool canScrollList = false;

  Room();

  factory Room.fromJson(Map json, bool fromDatabase) {

    DateTime? createAtLocal;
    DateTime? changeAtLocal;

    createAtLocal = DateTime.tryParse(json['createAt']);
    changeAtLocal = DateTime.tryParse(json['changeAt']);
    if (json['createAt'] != null) {
      createAtLocal = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(createAtLocal.toString(), true)
          .toLocal();
    }
    if (json['changeAt'] != null) {
      changeAtLocal = DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(changeAtLocal.toString(), true)
          .toLocal();
    }

    return Room()
      ..id = json['_id']
      ..roomName = json['roomName']
      ..lastIndex = json['property']['lastIndex']
      ..canSendChat = json['property']['canSendChat'] ?? false
      ..membersLength = json['property']['membersLength']
      ..changeAt = changeAtLocal
      ..createAt = createAtLocal
      ..deleted = json['deleted']
      ..identifier = json['identifier']
      ..verified = json['verified'] ?? false
      ..minViewPortSeenIndex = json['minViewPortSeenIndex'] ?? 0
      ..members = json['members'] == null ? null : (json['members'] as List).map((member) {
        var roomMember = RoomMember.fromJson(member);
        return roomMember;
      }).toList()
      ..roomType = _RoomUtils.roomTypeFromText(json['roomType'])
      ..lastChat =
          json['lastChat'] == null ? null : Chat.detectChatModelType(json['lastChat'])
      ..roomImage = json['roomImage'];
  }

  @override
  Map<String, dynamic> toSaveFormat() => {
        '_id': id,
        'roomName': roomName,
        'changeAt': changeAt?.toUtc().toString(),
        'createAt': createAt?.toUtc().toString(),
        'deleted': deleted,
        'members': members,
        'identifier': identifier,
        'verified': verified,
        'roomType': _RoomUtils.roomTypeToString(roomType!),
        'lastChat': lastChat?.toSaveFormat(),
        'roomImage': roomImage,
        'property': {
          'lastIndex': lastIndex,
          'canSendChat': canSendChat,
          'membersLength': membersLength,
        },
        'minViewPortSeenIndex': minViewPortSeenIndex,
      };

  static populateRoomFields(Room room, User myAccount) =>
      _RoomUtils.populateRoomFields(room, myAccount);

  static generateProfileImageByName(Room room) =>
      _RoomUtils.generateProfileImageByName(room);
}

enum RoomType { pvUser, publicGroup, pvGroup, channel, updateRequired }

class _RoomUtils {

  static Widget generateProfileImageByName(Room room) {
    String name = room.roomName ?? 'guest';
    String family = '';
    try{
      if (name.contains(' ')) {
        family = ' ' + name.split(' ')[1][0];
      }
    }catch(e){
      if (kDebugMode) {
        print('generateProfileImageByName exception : $e');
      }
    }

    return Center(child: AppText(name[0] + family));
  }

  static populateRoomFields(Room room, User myAccount) {
    switch (room.roomType) {
      case RoomType.pvUser:
        if (room.members?[0].user?.id == myAccount.id &&
            room.members?[1].user?.id == myAccount.id) {
          room.roomName = 'My Messages';
          room.roomImage = myAccount.profileUrl;
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
      default:
        {}
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

  static String roomTypeToString(RoomType roomType) {
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
