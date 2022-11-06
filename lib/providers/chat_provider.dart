import 'package:chat_babakcode/constants/config.dart';
import 'package:chat_babakcode/main.dart';
import 'package:chat_babakcode/models/room.dart';
import 'package:chat_babakcode/models/user.dart';
import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_page.dart';
import 'package:chat_babakcode/utils/utils.dart';
import 'package:emoji_picker_flutter/src/emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

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
    socket.onError(handleErrors);

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
          notifyListeners();
        }
      }catch(e){}
    });
    socket.on('receiveChat', (data) {
      print('receiveChat => $data');
      Chat chat = Chat.fromJson(data);
      Room? targetRoom = rooms.firstWhere((element) => element.id == chat.roomId);
      targetRoom.lastChat = chat;
      notifyListeners();
      // if(data['success']){
      //
      //   final roomId = data['roomId'];
      //   Room? targetRoom = rooms.firstWhere((element) => element.id == roomId);
      //   targetRoom.lastChat = Chat.fromJson(data['chat']);
      //   notifyListeners();
      // }
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

  void handleErrors(error) async {
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

  void sendTestToSocket() {
    socket.emit('messages', 'hi');

    // socket.emit('create_group', 'hi');
  }

  Room? selectedRoom;


  void addPvUserRoom({required String token}) {
    socket.emitWithAck('addConversation', {'type': 'pvUser', 'token': token},
        ack: (data) {
      print(data);

      if (data['success']) {

        selectedRoom = Room.fromJson(data['room']);
        // if (data['room'] == null) {
        //   selectedRoom = Room(id: null,
        //       roomName: user.name!,
        //       changeAt: null,
        //       createAt: null,
        //       removed: false,
        //       members: [RoomMember()..user = user, RoomMember()..user= auth!.myUser!],
        //       roomType: RoomType.pvUser,
        //       lastChat: null,
        //       roomImage: user.profileUrl,
        //       newRoomToGenerate: true,
        //       chatList: []);
        // } else {
        // }

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
        notifyListeners();
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
