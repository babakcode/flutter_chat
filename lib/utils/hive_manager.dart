import 'package:chat_babakcode/models/chat.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/room.dart';
import '../models/user.dart';

class HiveManager {
  static bool saveCancel = false;
  final List<String> _localCheckedUsers = [];

  final _roomBox = Hive.box<Map>('room');
  final _usersBox = Hive.box<Map>('user');
  final _chatsBox = Hive.box<Map>('chat');

  Future<void> saveChats(List<Chat> chats) async {
    if(saveCancel) {
      return;
    }
    for (var chat in chats) {
      if (chat.deleted!) {
        _chatsBox.delete(chat.id!);
        continue;
      }
      Map saveChatItemMap = chat.toSaveFormat();

      await _updateUserIfExist(chat.user!);
      saveChatItemMap['user'] = chat.user!.id!;

      //#region replayId to save format
      if (chat.replyId != null) {
        Chat replayChat = chat.replyId!;
        await _updateUserIfExist(replayChat.user!);
        replayChat.replyId = null;
        var saveReplayChatMap = replayChat.toSaveFormat();
        saveChatItemMap['replayId']['user'] = replayChat.user!.id;
        saveChatItemMap['replayId'] = saveReplayChatMap;
      }
      //#endregion

      await _chatsBox.put(chat.id, saveChatItemMap);
    }
  }

  Future<void> saveRooms(List<Room> rooms) async {
    if(saveCancel) {
      return;
    }
    for (var room in rooms) {
      /// check removed
      if (room.deleted!) {
        await _roomBox.delete(room.id!);
        continue;
      }
      Map saveRoomItem = room.toSaveFormat();

      /// convert members to array<Map> members
      //#region members to map list
      List<Map> arrayMembers = [];
      for (var member in room.members) {
        Map saveMemberMap = member.toSaveFormat();

        /// check the user checked once or not
        await _updateUserIfExist(member.user!);
        saveMemberMap['user'] = member.user!.id!;
        arrayMembers.add(saveMemberMap);
      }
      saveRoomItem['members'] = arrayMembers;
      //#endregion

      /// change user to map
      //#region user to Map
      if (room.lastChat != null) {
        await _updateUserIfExist(room.lastChat!.user!);
        // print(saveRoomItem['lastChat']);
        saveRoomItem['lastChat']['user'] = room.lastChat!.user!.id;
      }
      //#endregion

      if (kDebugMode) {
        print('-------[saveRoomItem]- start -----');
        print(saveRoomItem);
      }
      await _roomBox.put(room.id, saveRoomItem);
      if (kDebugMode) {
        print('saved successfully');
        print('-------[saveRoomItem]- end -----');
      }
    }
  }

  Future<void> _updateUserIfExist(User user) async {
    if(saveCancel) {
      return;
    }
    if (!_localCheckedUsers.contains(user.id)) {
      /// else check for one more time
      final userFound = _usersBox.get(user.id);
      if (userFound != null && userFound['__v'] < user.version) {
        // update user
        _localCheckedUsers.add(user.id!);
      }
      await _usersBox.put(user.id, user.toSaveFormat());
    }
  }

  Future<List<Room>> getAllRooms() async {
    List<Room> rooms = [];
    for (var savedRoom in _roomBox.values) {
      //#region change userIdes to user object
      for (var savedMember in (savedRoom['members'] as List)) {
        print(savedMember);
        if (savedMember['user'] is String) {
          final foundUser = _usersBox.get(savedMember['user']);
          savedMember['user'] = foundUser;
        }
      }
      //#endregion

      //#region change last chat user id to user object if last chat not null
      var _savedLastChatOfRoom = savedRoom['lastChat'];
      if (_savedLastChatOfRoom != null) {
        if(_savedLastChatOfRoom['user'] is String){
          _savedLastChatOfRoom['user'] =
              _usersBox.get(_savedLastChatOfRoom['user']);
        }
      }
      //#endregion

      // then add room
      rooms.add(Room.fromJson(savedRoom));
    }
    return rooms;
  }

  Future<void> clearRooms() async {
    await _roomBox.clear();
  }

  Future<List<Chat>> getAllChatsOf(Room room) async {
    List<Chat> roomChatList = [];
    final _savedChatList = _chatsBox.values
        .where((element) => element['room'] == room.id)
        .toList();
    for (var item in _savedChatList) {
      if (item['replayId'] != null) {
        item['replayId']['user'] = _usersBox.get(item['replayId']['user']);
      }

      item['user'] = _usersBox.get(item['user']);
      roomChatList.add(Chat.fromJson(item));
    }
    return roomChatList;
  }

  void updateMinViewPortSeenIndexOfRoom(int min, Room selectedRoom) {
    if(saveCancel) {
      return;
    }
    var room = _roomBox.get(selectedRoom.id);
    if (room != null && room['minViewPortSeenIndex'] != min) {
      room['minViewPortSeenIndex'] = min;
      _roomBox.put(room['_id'], room);
    }
  }

  void updateLastIndexOfRoom(int lastIndex, Room selectedRoom) {
    if(saveCancel) {
      return;
    }
    var room = _roomBox.get(selectedRoom.id);
    if (room != null && room['property']['lastIndex'] != lastIndex) {
      room['property']['lastIndex'] = lastIndex;
      _roomBox.put(room['_id'], room);
    }
  }
}
