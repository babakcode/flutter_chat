import 'package:chat_babakcode/constants/config.dart';
import 'package:chat_babakcode/main.dart';
import 'package:chat_babakcode/models/app_collection.dart';
import 'package:chat_babakcode/models/room.dart';
import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_page.dart';
import 'package:chat_babakcode/utils/utils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

  /// auth provider proxy
  Auth? auth;

  void initAuth(Auth auth) => this.auth = auth;

  ChatProvider() {
    // socket events
    socket.onReconnect((_) => debugPrint('socket reconnected'));
    socket.onConnect((_) {
      debugPrint('socket connected');
      socket.emit('getAllMessages', auth?.lastGroupLoadedDate);
    });
    socket.onDisconnect((_) => debugPrint('socket disconnected'));
    socket.onConnectError(_handleSocketErrorsEvent);
    socket.onError(_handleSocketErrorsEvent);
    socket.on('userRoomChats', _userRoomChatsEvent);
    socket.on('userRooms', _userRoomsEvent);
    socket.on('receiveChat', _receiveChatEvent);

    /// check keyboard appeared
    chatFocusNode.addListener(() {
      if (chatFocusNode.hasFocus) {
        if (showSticker || emojiShowing) {
          showSticker = false;
          emojiShowing = false;
          notifyListeners();
        }
      }
    });

    /// chat text edit controller listener
    chatController.addListener(() {
      bool showSendChat = chatController.text.isNotEmpty;
      if (showSendChat != this.showSendChat) {
        this.showSendChat = showSendChat;
        notifyListeners();
      }
    });

    itemPositionsListener.itemPositions.addListener(changeScrollIndexListener);
  }

  void changeScrollIndexListener() {
    if (selectedRoom == null) {
      return;
    }

    selectedRoom!.minViewPortSeenIndex = minIndexOfChatListOnViewPort;
    if ((selectedRoom!.lastIndex ?? -1) < maxIndexOfChatListOnViewPort) {
      selectedRoom!.lastIndex = maxIndexOfChatListOnViewPort;
    }

    // selectedRoom!.roomPositionIndex = RoomPositionIndex(min, max);
  }

  void disconnectSocket() {
    socket.disconnect();
  }

  SavableList<Room> rooms = SavableList(collection: 'room');

  // final _hiveManager = HiveManager();

  ItemScrollController itemScrollController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  int get maxIndexOfChatListOnViewPort =>
      itemPositionsListener.itemPositions.value
          .where((ItemPosition position) => position.itemLeadingEdge < 1)
          .reduce((ItemPosition max, ItemPosition position) =>
              position.itemLeadingEdge > max.itemLeadingEdge ? position : max)
          .index;

  int get minIndexOfChatListOnViewPort =>
      itemPositionsListener.itemPositions.value
          .where((ItemPosition position) => position.itemTrailingEdge > 0)
          .reduce((ItemPosition min, ItemPosition position) =>
              position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
          .index;

  Room? selectedRoom;

  void searchRoomWith(
      {required String roomType,
      required String searchType,
      required String searchText,
      required BuildContext context,
      Function? callBack}) {
    /// search from exist rooms
    /// then if not find room,
    /// search from server

    bool foundLocalExistGroup = false;
    rooms
        .where((element) => element.roomType == RoomType.pvUser)
        .toList()
        .forEach((room) {
      if (room.members!
          .where((element) =>
              ((searchType == 'token')
                  ? element.user!.publicToken
                  : element.user?.username) ==
              searchText)
          .isNotEmpty) {
        /// room found
        selectedRoom = room;
        Navigator.pop(context);
        if (GlobalSettingProvider.isPhonePortraitSize) {
          Navigator.push(
              navigatorKey.currentContext!,
              CupertinoPageRoute(
                builder: (context) => const ChatPage(),
              ));
        } else {
          notifyListeners();
        }
        foundLocalExistGroup = true;
        callBack?.call({
          'success': true,
          'findFromExistRoom': true,
        });
      }
    });
    if (foundLocalExistGroup) {
      return;
    }

    socket.emitWithAck('searchRoom', {
      'searchType': searchType,
      'roomType': roomType,
      'searchText': searchText,
    }, ack: (data) {
      if (kDebugMode) {
        print(data);
      }

      if (data['success']) {
        callBack?.call({
          'success': true,
          'findFromExistRoom': false,
        });
        Navigator.pop(context);
        selectedRoom = Room.fromJson(data['room']);

        if (GlobalSettingProvider.isPhonePortraitSize) {
          Navigator.push(
            navigatorKey.currentContext!,
            CupertinoPageRoute(
              builder: (context) => const ChatPage(),
            ),
          );
        } else {
          notifyListeners();
        }
      } else {
        callBack?.call(
            {'success': false, 'findFromExistRoom': false, 'msg': data['msg']});
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
    if (chatController.text.isEmpty) {
      return;
    }
    Map data = {
      'roomId': room.id ?? 'new',
      'chat': chatController.text,
      'type': 'text'
    };

    if (room.id == null &&
        room.roomType == RoomType.pvUser &&
        room.newRoomToGenerate) {
      data['userId'] = room.members!
          .firstWhere((element) => element.user!.id != auth!.myUser!.id!)
          .user!
          .id;
    }
    socket.emitWithAck('sendChat', data, ack: (data) {
      if (kDebugMode) {
        print(data);
      }
      if (data['success']) {
        chatController.clear();
        notifyListeners();
      } else {
        Utils.showSnack(navigatorKey.currentContext!, data['msg']);
      }
    });
  }

  void recordStart() {}

  void recordStop(BuildContext context, Room room) {}

  void onEmojiSelected(Emoji emoji) {
    chatController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: chatController.text.length));
  }

  void onBackspacePressed() {
    chatController
      ..text = chatController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: chatController.text.length));
  }

  void changeSelectedRoom(Room room) async {
    if (GlobalSettingProvider.isPhonePortraitSize) {
      selectedRoom = room;
      notifyListeners();
      return;
    }
    if (selectedRoom != null) {
      deselectRoom();
    }

    await Future.delayed(
        const Duration(milliseconds: 100), () => selectedRoom = room);
    notifyListeners();
  }

  void deselectRoom() {
    selectedRoom = null;
    notifyListeners();
  }

  void _userRoomChatsEvent(data) {
    if (kDebugMode) {
      print('userRoomChats => $data');
    }

    /// todo : check exist list before add data
    try {
      if (data['success']) {
        final roomId = data['roomId'];
        final indexOfRoom = rooms.indexWhere((element) => element.id == roomId);
        if (indexOfRoom != -1) {
          rooms
              .get(indexOfRoom)
              .chatList
              .addAll(Chat.getChatsFromJsonList(data['chats']));
        }
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('userRoomChats exception: $e');
      }
    }
  }

  void _userRoomsEvent(data) {
    if (kDebugMode) {
      print('userRooms => $data');
    }
    try {
      if (data['success']) {
        for (Map room in (data['rooms'] as List)) {
          if (rooms.where((element) => element.id == room['_id']).isEmpty) {
            rooms.add(Room.fromJson(room));
          }
        }

        rooms.sort(
            (a, b) => b.lastChat!.utcDate!.compareTo(a.lastChat!.utcDate!));
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('userRooms exception $e');
      }
    }
  }

  void _receiveChatEvent(data) async {
    if (kDebugMode) {
      print('receiveChat => $data');
    }
    try {
      Chat chat = Chat.fromJson(data['chat']);

      int indexOfRoom =
          rooms.indexWhere((element) => element.id == chat.roomId);
      if (indexOfRoom == -1) {
        /// request to get room details
        /// or insert from chat `room` property
        Room room = Room.fromJson(data['room']);

        rooms.add(room);

        /// after get room, update ``indexOfRoom``
        indexOfRoom = rooms.indexOf(room);
      }
      Room targetRoom = rooms.get(indexOfRoom);
      if (targetRoom.id == selectedRoom?.id) {
        selectedRoom = targetRoom;
      }
      if (targetRoom.lastChat == null || targetRoom.chatList.isEmpty) {
        targetRoom.lastChat = chat;
        targetRoom.chatList.add(chat);
      } else {
        /// if received new (chat number id) - 1 is room lastChat of
        /// `loaded` chat list number id
        /// then we reached to end of the chat list
        /// that means we won't load more of list
        if (chat.chatNumberId! - 1 ==
                targetRoom.chatList
                    .get(targetRoom.chatList.length - 1)
                    .chatNumberId ||
            targetRoom.reachedToEnd) {
          targetRoom.chatList.add(chat);
        } else {
          if (chat.user!.id == auth!.myUser!.id && !targetRoom.reachedToEnd) {
            /*
           todo: get the last 50 chats of the room if
            the sender user is from our account */

            // await get last 50 chats of group and
            // return now
          }
        }

        /// else just update the last chat of list
        targetRoom.lastChat = chat;
        targetRoom.changeAt = chat.utcDate;
      }

      rooms.sort((a, b) => b.changeAt!.compareTo(a.changeAt!));

      /// if we are at end of the list then scroll to received new chat
      if ((selectedRoom == targetRoom &&
              (maxIndexOfChatListOnViewPort - targetRoom.chatList.length)
                      .abs() <=
                  5) ||
          (selectedRoom == targetRoom && chat.user!.id == auth!.myUser!.id)) {
        itemScrollController.scrollTo(
            index: targetRoom.chatList.length - 1,
            duration: const Duration(milliseconds: 1000),
            alignment: .4);
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void _handleSocketErrorsEvent(error) async {
    try {
      debugPrint('socket Error $error');
      if (error['message'] == 'auth_error') {
        socket.disconnect();
        await auth?.logOut();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
