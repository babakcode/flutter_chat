import 'package:chat_babakcode/constants/config.dart';
import 'package:chat_babakcode/main.dart';
import 'package:chat_babakcode/models/room.dart';
import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_page.dart';
import 'package:chat_babakcode/utils/utils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../models/chat.dart';

class ChatProvider extends ChangeNotifier {

  io.Socket socket = io.io(
      AppConfig.socketBaseUrl,
      io.OptionBuilder()
          .enableForceNewConnection()
          .disableAutoConnect()
          .setTransports(['websocket']).build());

  Auth? auth;

  void initAuth(Auth auth) =>
    this.auth = auth;



  ChatProvider() {

    socket.onReconnect((data) => print('socket recconect'));
    socket.onConnect((_) {
      print('socket connected');
      socket.emit('getAllMessages', auth?.lastGroupLoadedDate);
    });
    socket.onConnectError((data) => print('socket Error $data'));
    socket.onDisconnect((data) => print('socket disconnected'));
    socket.onError(_handleSocketErrors);

    socket.on('userRoomChats', (data) {
      print('userRoomChats => $data');
      try{
        if(data['success']){
          final roomId = data['roomId'];
          rooms.firstWhere((element) => element.id == roomId).chatList = Chat.getChatsFromJsonList(data['chats']);
          notifyListeners();
        }
      }catch(e){
        print('userRoomChats exception: $e');
      }
    });
    socket.on('userRooms', (data){
      print('userRooms => $data');
      try{
        if(data['success']){
          for (Map room in (data['rooms'] as List)) {
            if(rooms.where((element) => element.id == room['_id']).isEmpty){
              rooms.add(Room.fromJson(room));
            }
          }
          rooms.sort((a, b) => b.lastChat!.utcDate!.compareTo(
              a.lastChat!.utcDate!));
          notifyListeners();

        }
      }catch(e){
        print('userRooms exception $e');
      }
    });
    socket.on('receiveChat', (data) {
      print('receiveChat => $data');
      Chat chat = Chat.fromJson(data);
      Room? targetRoom = rooms.firstWhere((element) => element.id == chat.roomId);
      targetRoom.lastChat = chat;
      int lastId = 1;
      try{
        lastId = targetRoom.chatList?.last.chatNumberId ?? 1;
      }catch(e){

      }

      
      if(( lastId  + 1) == chat.chatNumberId || lastId == 1){
        targetRoom.chatList!.add(chat);
        targetRoom.lastChat = chat;
        targetRoom.changeAt = chat.utcDate;
      }

      rooms.sort((a, b) => b.changeAt!.compareTo(
          a.changeAt!));
      notifyListeners();

      if(lastId != 1){
        int max = itemPositionsListener.itemPositions.value
            .where((ItemPosition position) => position.itemLeadingEdge < 1)
            .reduce((ItemPosition max, ItemPosition position) =>
        position.itemLeadingEdge > max.itemLeadingEdge
            ? position
            : max)
            .index;
        if(targetRoom.chatList![max].chatNumberId! >= lastId - 1){
          itemScrollController.scrollTo(index: targetRoom.chatList!.length - 1, duration: const Duration(milliseconds: 1000));
        }
      }
    });
    socket.on('check_update_room_messages', (data) {
      print('check_update_room_messages => $data');
    });

    chatFocusNode.addListener(() {
      if (chatFocusNode.hasFocus) {
        // keyboard appeared
        if (showSticker || emojiShowing) {
          showSticker = false;
          emojiShowing = false;
          notifyListeners();
        }
      }
    });

    chatController.addListener(() {
      bool showSendChat = chatController.text.isNotEmpty;
      if (showSendChat != this.showSendChat) {
        this.showSendChat = showSendChat;
        notifyListeners();
      }
    });

  }

  void changeScrollIndexListener(){
      if(selectedRoom == null){
        return;
      }

      int min = itemPositionsListener.itemPositions.value
          .where((ItemPosition position) => position.itemTrailingEdge > 0)
          .reduce((ItemPosition min, ItemPosition position) =>
      position.itemTrailingEdge < min.itemTrailingEdge
          ? position
          : min)
          .index;
      int max = itemPositionsListener.itemPositions.value
          .where((ItemPosition position) => position.itemLeadingEdge < 1)
          .reduce((ItemPosition max, ItemPosition position) =>
      position.itemLeadingEdge > max.itemLeadingEdge
          ? position
          : max)
          .index;
      print('max = $max');
      print('min = $min');
      // selectedRoom!.roomPositionIndex = RoomPositionIndex(min, max);
  }

  void _handleSocketErrors(error) async {
    try {
      print('socket Error $error');
      if (error['message'] == 'auth_error') {
        socket.disconnect();
        await auth?.logOut();
      }
    } catch (e) {
      print(e);
    }
  }

  void disconnectSocket() {
    socket.disconnect();
  }

  List<Room> rooms = [];

  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  Room? selectedRoom;

  void addPvUserRoom({required String token}) {
    socket.emitWithAck('addConversation', {'type': 'pvUser', 'token': token},
        ack: (data) {
      print(data);

      if (data['success']) {

        selectedRoom = Room.fromJson(data['room']);

        if (GlobalSettingProvider.isPhonePortraitSize) {
          Navigator.push(
            navigatorKey.currentContext!,
            CupertinoPageRoute(
              builder: (context) => ChatPage(),
            ),
          );
        } else {
          notifyListeners();
        }
      }
    });
  }

  TextEditingController chatController = TextEditingController();

  bool showSendChat = false;

  FocusNode chatFocusNode = FocusNode();

  bool emojiShowing = false;
  bool showSticker = false;

  void emojiToggle() {
    emojiShowing = !emojiShowing;
    if (emojiShowing) {
      if (chatFocusNode.hasFocus) {
        FocusManager.instance.primaryFocus?.unfocus();
      }

      if (showSticker) {
        showSticker = false;
      }
    }
    notifyListeners();
  }

  void stickerToggle() {}

  void sendText(Room room) {
    if(chatController.text.isEmpty){
      return;
    }
    Map data = {
      'roomId': room.id ?? 'new',
      'chat': chatController.text,
      'type': 'text'
    };

    if(room.id == null && room.roomType == RoomType.pvUser && room.newRoomToGenerate){
      data['userId'] = room.members!.firstWhere((element) => element.user!.id != auth!.myUser!.id!).user!.id;
    }
    socket.emitWithAck('sendChat', data, ack: (data){
      print(data);
      if(data['success']){
        chatController.clear();
        notifyListeners();
        itemScrollController.scrollTo(index: room.chatList!.length - 1, duration: const Duration(milliseconds: 1000));
      }else{
        Utils.showSnack(navigatorKey.currentContext!, data['msg']);
      }
    });
  }

  void recordStart() {}

  recordStop(BuildContext context, Room room) {}

  onEmojiSelected(Emoji emoji) {
    chatController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: chatController.text.length));
  }

  onBackspacePressed() {
    chatController
      ..text = chatController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: chatController.text.length));
  }

  void changeSelectedRoom(Room room) {
    selectedRoom = room;
    notifyListeners();
  }

  void deselectRoom() {
    selectedRoom = null;
    notifyListeners();
  }

}
