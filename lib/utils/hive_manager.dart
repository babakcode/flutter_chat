import 'dart:math';

import 'package:chat_babakcode/models/chat.dart';
import 'package:chat_babakcode/models/room_member.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/room.dart';
import '../models/user.dart';

class HiveManager {
  static bool saveCancel = false;
  final List<String> _localCheckedUsers = [];

  final roomBox = Hive.box<Map>('room');
  final usersBox = Hive.box<Map>('user');
  final chatsBox = Hive.box<Map>('chat');

  Future<void> saveChats(List<Chat> chats,String room, {bool clearSavedList = false}) async {
    if(saveCancel) {
      return;
    }
    if(clearSavedList){
      for( var item in chatsBox.values.where((element) => element['room'] == room)){
        await chatsBox.delete(item['_id']);
      }
    }
    for (var chat in chats) {
      if (chat.deleted!) {
        chatsBox.delete(chat.id!);
        continue;
      }
      Map saveChatItemMap = chat.toSaveFormat();

      await _updateUserIfExist(chat.user!);
      saveChatItemMap['user'] = chat.user!.id!;

      //#region replyId to save format
      if (chat.replyId != null) {
        Chat replyChat = chat.replyId!;
        await _updateUserIfExist(replyChat.user!);
        replyChat.replyId = null;
        final saveReplyChatMap = Chat.chatToMap(replyChat);
        saveChatItemMap['replyId'] = saveReplyChatMap;
        saveChatItemMap['replyId']['user'] = replyChat.user!.id;
      }
      //#endregion

      await chatsBox.put(chat.id, saveChatItemMap);
    }
  }

  Future<void> saveRooms(List<Room> rooms) async {
    if(saveCancel) {
      return;
    }
    for (var room in rooms) {
      /// check removed
      if (room.deleted!) {
        await roomBox.delete(room.id!);
        continue;
      }
      Map saveRoomItem = room.toSaveFormat();

      if(room.members != null){

        /// convert members to array<Map> members
        //#region members to map list
        List<Map> arrayMembers = [];
        for (RoomMember member in room.members!) {
          Map saveMemberMap = member.toSaveFormat();

          /// check the user checked once or not
          await _updateUserIfExist(member.user!);
          saveMemberMap['user'] = member.user!.id!;
          arrayMembers.add(saveMemberMap);
        }
        saveRoomItem['members'] = arrayMembers;
        //#endregion

      }

      /// change user to map
      //#region user to Map
      if (room.lastChat != null) {
        await _updateUserIfExist(room.lastChat!.user!);
        // print(saveRoomItem['lastChat']);
        saveRoomItem['lastChat']['user'] = room.lastChat!.user!.id;
      }
      //#endregion

      await roomBox.put(room.id, saveRoomItem);
    }
  }

  Future<void> _updateUserIfExist(User user) async {
    if(saveCancel) {
      return;
    }
    if (!_localCheckedUsers.contains(user.id)) {
      /// else check for one more time
      final userFound = usersBox.get(user.id);
      if (userFound != null && userFound['__v'] < user.version) {
        // update user
        _localCheckedUsers.add(user.id!);
      }
      await usersBox.put(user.id, user.toSaveFormat());
    }
  }

  Future<List<Room>> getAllRooms() async {
    List<Room> rooms = [];
    for (var savedRoom in roomBox.values) {
      //#region change userIdes to user object
      for (var savedMember in (savedRoom['members'] as List)) {
        if (savedMember['user'] is String) {
          final foundUser = usersBox.get(savedMember['user']);
          savedMember['user'] = foundUser;
        }
      }
      //#endregion

      //#region change last chat user id to user object if last chat not null
      var _savedLastChatOfRoom = savedRoom['lastChat'];
      if (_savedLastChatOfRoom != null) {
        if(_savedLastChatOfRoom['user'] is String){
          _savedLastChatOfRoom['user'] =
              usersBox.get(_savedLastChatOfRoom['user']);
        }
        if(_savedLastChatOfRoom['replyId'] is String){
          _savedLastChatOfRoom['replyId'] = chatsBox.get(_savedLastChatOfRoom['replyId']);
        }
      }
      //#endregion

      // then add room
      rooms.add(Room.fromJson(savedRoom, true));
    }
    return rooms;
  }

  Future<void> clearRooms() async {
    await roomBox.clear();
  }

  Future<List<Chat>> getAllChatsOf(Room room) async {
    List<Chat> roomChatList = [];
    final _savedChatList = chatsBox.values
        .where((element) => element['room'] == room.id)
        .toList();
    for (var item in _savedChatList) {
      if (item['replyId'] != null) {
        item['replyId']['user'] = usersBox.get(item['replyId']['user']);
      }

      item['user'] = usersBox.get(item['user']);
      roomChatList.add(Chat.detectChatModelType(item));
    }
    return roomChatList;
  }

  Future updateMinViewPortSeenIndexOfRoom(int min, Room selectedRoom) async {
    if(saveCancel) {
      return;
    }
    var room = roomBox.get(selectedRoom.id);
    if (room != null && room['minViewPortSeenIndex'] != min) {
      room['minViewPortSeenIndex'] = min;
      await roomBox.put(room['_id'], room);
    }
  }

  Future updateLastIndexOfRoom(int lastIndex, Room selectedRoom)async {
    if(saveCancel) {
      return;
    }
    if (kDebugMode) {
      print('updateLastIndexOfRoom ( lastIndex: $lastIndex , selectedRoom: ${selectedRoom.id}');
    }
    var room = roomBox.get(selectedRoom.id);
    if (room != null && room['property']['lastIndex'] != lastIndex) {
      room['property']['lastIndex'] = lastIndex;
      await roomBox.put(room['_id'], room);
      selectedRoom.lastIndex = lastIndex;
    }
  }

  void updateRoom(Room room)async {
    /// check removed
    if (room.deleted!) {
      await roomBox.delete(room.id!);
    }
    Map saveRoomItem = room.toSaveFormat();


    if(room.members != null){

      /// convert members to array<Map> members
      //#region members to map list
      List<Map> arrayMembers = [];
      for (var member in room.members!) {
        Map saveMemberMap = member.toSaveFormat();

        /// check the user checked once or not
        await _updateUserIfExist(member.user!);
        saveMemberMap['user'] = member.user!.id!;
        arrayMembers.add(saveMemberMap);
      }
      saveRoomItem['members'] = arrayMembers;
      //#endregion

    }
    /// change user to map
    //#region lastChat user to Map
    if (room.lastChat != null) {
      await _updateUserIfExist(room.lastChat!.user!);
      // print(saveRoomItem['lastChat']);
      saveRoomItem['lastChat']['user'] = room.lastChat!.user!.id;
      //#region user to Map
      if (room.lastChat!.replyId != null) {


        await _updateUserIfExist(room.lastChat!.replyId!.user!);
        // print(saveRoomItem['lastChat']);
        final replyChat = room.lastChat!.replyId!;
        replyChat.replyId = null;
        final saveReplyChatMap = Chat.chatToMap(replyChat);
        saveRoomItem['lastChat']['replyId'] = saveReplyChatMap;
        saveRoomItem['lastChat']['replyId']['user'] = replyChat.user!.id;
      }
      //#endregion
    }
    //#endregion


    await roomBox.put(room.id, saveRoomItem);
  }

  Future clear() async{
    await chatsBox.clear();
    await roomBox.clear();
    await usersBox.clear();
  }

  Future<void> deleteChat(String chatId, Room room) async{
    await chatsBox.delete(chatId);
    final indexOfChat = room.chatList.indexWhere((element) => element.id == chatId);
    if(indexOfChat != -1){
      room.chatList.removeAt(indexOfChat);
    }
  }
}
