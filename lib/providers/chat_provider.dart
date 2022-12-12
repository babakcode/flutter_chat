import 'dart:convert';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:chat_babakcode/utils/firebase_maager.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chat_babakcode/main.dart';
import 'package:chat_babakcode/models/room.dart';
import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/utils/utils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/chat.dart';
import '../models/upload_file_model.dart';
import '../utils/hive_manager.dart';

class ChatProvider extends ChangeNotifier {
  io.Socket socket = io.io(
      AppConstants.socketBaseUrl,
      io.OptionBuilder()
          .enableForceNewConnection()
          .disableAutoConnect()
          .setTransports(['websocket']).build());

  /// auth provider proxy
  Auth? auth;


  void initAuth(Auth auth) => this.auth = auth;

  Future saveLastViewPortSeenIndex(Room selectedRoom) async {
    try {
      if (selectedRoom.chatList.isNotEmpty) {
        if (selectedRoom.minViewPortSeenIndex != minIndexOfChatListOnViewPort) {
          // save on database
          _hiveManager.updateMinViewPortSeenIndexOfRoom(
              minIndexOfChatListOnViewPort, selectedRoom);
          // save to local list
          selectedRoom.minViewPortSeenIndex = minIndexOfChatListOnViewPort;
        }

        if ((selectedRoom.lastIndex ?? -1) <=
            selectedRoom.chatList[maxIndexOfChatListOnViewPort].chatNumberId!) {
          // save on database
          Future.microtask(() {
            _hiveManager.updateLastIndexOfRoom(
                selectedRoom
                    .chatList[maxIndexOfChatListOnViewPort].chatNumberId!,
                selectedRoom);
            notifyListeners();
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('saveLastViewPortSeenIndex exception $e');
      }
    }
  }

  void connectSocket() {
    setConnectionStatus = 'Connecting ...';
    // chatProvider?.clearRoomsList();
    // HiveManager.saveCancel = true;
    getAllRooms();

    socket
      ..auth = {'token': auth?.accessToken}
      ..connect();
  }

  ChatProvider() {
    // socket events
    socket.onConnect((_) {
      setConnectionStatus = 'Connected';
      debugPrint('socket connected');

      String? lastViewedDate;
      if (auth?.lastGroupLoadedDate != null) {
        lastViewedDate = auth!.lastGroupLoadedDate;
        if (lastViewedDate!.split('').last != 'Z') {
          lastViewedDate += 'Z';
        }
      }

      socket.emit('getAllMessages', lastViewedDate);

      _sendOnceFirebaseToken();
      _checkOnceUpdate();
    });
    socket.onDisconnect((_) {
      debugPrint('socket disconnected');
      setConnectionStatus = 'Connecting ...';
    });
    socket.onConnectError(_handleSocketErrorsEvent);
    socket.onError(_handleSocketErrorsEvent);
    socket.on('userRooms', _userRoomsEvent);
    socket.on('userRoomChats', _userRoomChatsEvent);
    socket.on('receiveChat', _receiveChatEvent);
    socket.on('action', _actionEvent);

    /// check keyboard appeared
    chatFocusNode.addListener(() {
      if (chatFocusNode.hasFocus) {
        if (showSticker || showEmoji || showShareFile) {
          showSticker = false;
          showShareFile = false;
          showEmoji = false;
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

    // itemPositionsListener.itemPositions.addListener(changeScrollIndexListener);
  }

  set setConnectionStatus(String? set) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        connectionStatus = set;
        notifyListeners();
      },
    );
  }

  String? connectionStatus;

  void changeScrollIndexListener() {
    if (selectedRoom == null) {
      return;
    }

    //
    // if (selectedRoom!.minViewPortSeenIndex != minIndexOfChatListOnViewPort) {
    //   // save on database
    //   _hiveManager.updateMinViewPortSeenIndexOfRoom(
    //       minIndexOfChatListOnViewPort, selectedRoom!);
    //   // save to local list
    //   selectedRoom!.minViewPortSeenIndex = minIndexOfChatListOnViewPort;
    // }

    if (selectedRoom!.chatList.isNotEmpty &&
        selectedRoom!.lastChat?.id == selectedRoom!.chatList.last.id) {
      selectedRoom!.reachedToEnd = true;
    }

    // try {
    //   if ((selectedRoom!.lastIndex ?? -1) <
    //       (selectedRoom!.chatList[maxIndexOfChatListOnViewPort].chatNumberId ??
    //           0)) {
    //     // save on database
    //     _hiveManager.updateLastIndexOfRoom(
    //         selectedRoom!.chatList[maxIndexOfChatListOnViewPort].chatNumberId!, selectedRoom!);
    //     notifyListeners();
    //
    //   }
    // } catch (e) {
    //   if (kDebugMode) {
    //     print(e);
    //   }
    // }

    /// load more (next) chats
    ///
    /// change reachedToEnd to true when the chat list empty after request
    if (selectedRoom!.chatList.isNotEmpty &&
        (selectedRoom!.chatList.indexOf(selectedRoom!.chatList.last) -
                    maxIndexOfChatListOnViewPort)
                .abs() <=
            3 &&
        !selectedRoom!.reachedToEnd &&
        !loadingLoadMoreNext &&
        selectedRoom!.lastChat!.chatNumberId !=
            selectedRoom!.chatList.last.chatNumberId) {
      loadingLoadMoreNext = true;
      _loadMoreNext();
    } else if (minIndexOfChatListOnViewPort <= 3 &&
        selectedRoom!.reachedToStart == false &&

        /// load more (previous) chats
        ///
        /// change reachedToStart to true when the chat list empty after request
        selectedRoom!.chatList.isNotEmpty &&
        minIndexOfChatListOnViewPort == 0 &&
        !selectedRoom!.reachedToStart &&
        !loadingLoadMorePrevious) {
      _loadMorePrevious();
    }
  }

  void disconnectSocket() {
    socket.disconnect();
  }

  TextEditingController chatController = TextEditingController();

  FocusNode chatFocusNode = FocusNode();

  final ImagePicker imagePicker = ImagePicker();

  bool showPreUploadFile = false;
  List<UploadFileModel> preUploadFiles = [];

  bool showShareFile = false;
  bool showEmoji = false;
  bool showSticker = false;
  bool loadingLoadMoreNext = false;
  bool loadingLoadMorePrevious = false;
  bool showSendChat = false;

  List<Room> rooms = [];
  final _hiveManager = HiveManager();

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

  void emojiToggle() {
    showEmoji = !showEmoji;
    if (showEmoji) {
      if (chatFocusNode.hasFocus) {
        FocusManager.instance.primaryFocus?.unfocus();
      }

      if (showSticker || showShareFile) {
        showSticker = false;
        showShareFile = false;
      }
    }
    notifyListeners();
  }

  void shareFileToggle() {
    showShareFile = !showShareFile;
    if (showShareFile) {
      if (chatFocusNode.hasFocus) {
        FocusManager.instance.primaryFocus?.unfocus();
      }

      if (showSticker || showEmoji) {
        showSticker = false;
        showEmoji = false;
      }
    }
    notifyListeners();
  }

  void stickerToggle() {
    showSticker = !showSticker;
    if (showSticker) {
      if (chatFocusNode.hasFocus) {
        FocusManager.instance.primaryFocus?.unfocus();
      }

      if (showEmoji || showShareFile) {
        showEmoji = false;
        showShareFile = false;
      }
    }
    notifyListeners();
  }

  void searchUser(
      {required String searchType,
      required String searchText,
      required BuildContext context,
      required Function callBack}) {
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
        foundLocalExistGroup = true;
        callBack
            .call({'success': true, 'findFromExistRoom': true, 'room': room});
      }
    });
    if (foundLocalExistGroup) {
      return;
    }

    socket.emitWithAck('searchUser', {
      'searchType': searchType,
      'searchText': searchText,
    }, ack: (data) {
      if (kDebugMode) {
        print("socket.emitWithAck('searchUser', data = $data);");
      }

      if (data['success']) {
        callBack.call({
          'success': true,
          'findFromExistRoom': false,
          'room': Room.fromJson(data['room'], false)
        });
      } else {
        callBack.call(
            {'success': false, 'findFromExistRoom': false, 'msg': data['msg']});
        Utils.showSnack(context, data['msg']);
      }
    });
  }

  Chat? replyTo;

  void emitText(Room room) {
    if (!showSendChat) {
      return;
    }
    if (chatController.text.isEmpty) {
      return;
    }
    print("replyTo != null = ${replyTo != null}");
    print("reply : ${replyTo?.toSaveFormat()}");

    Map data = {
      'roomId': room.id ?? 'new',
      'chat': chatController.text,
      'type': 'text',
      'replyId': replyTo?.id
    };

    final fakeChat = ChatTextModel({
      'text': chatController.text,
      'id':
          room.chatList.isNotEmpty ? (room.chatList.last.chatNumberId! + 1) : 1,
      'room': room.id,
      'user': auth?.myUser?.toSaveFormat(),
      'deleted': false,
      'utcDate': DateTime.now().toUtc().toString(),
      'edited': false, //replyId
      'replyId': Chat.chatToMap(replyTo),
      '__v': 0
    });
    fakeChat.sendSuccessfully = false;

    room.chatList.add(fakeChat);
    notifyListeners();

    if (selectedRoom == room) {
      /// if we are at end of the list then scroll to received new chat
      if ((room.chatList.length > 5 &&
              (maxIndexOfChatListOnViewPort - (room.chatList.length - 1))
                      .abs() <=
                  2) ||
          (room.chatList.length > 5 &&
              selectedRoom == room &&
              fakeChat.user!.id == auth!.myUser!.id)) {
        itemScrollController.scrollTo(
            index: room.chatList.length - 1,
            alignment: 0.1,
            duration: const Duration(milliseconds: 1000));
      }
    }

    chatController.clear();
    if (replyTo != null) {
      clearChatReply();
    }

    socket.emitWithAck('sendChat', data, ack: (data) {
      if (kDebugMode) {
        print('sendChat ack res: $data');
      }
      if (data['success']) {
        _receiveChatEvent(data, fakeChat);
      } else {
        Utils.showSnack(navigatorKey.currentContext!, data['msg']);
      }
    });
  }

  Future emitFile(Room room) async {
    final sendFiles = preUploadFiles;
    String chatText = chatController.text;
    for (int i = 0; i < sendFiles.length; i++) {
      final file = sendFiles[i];

      /// roomId, chat, file, type, fileName
      Map data = {
        'roomId': room.id!,
        'chat': i == sendFiles.length - 1 ? chatText : null,
        'type': file.type,
        'file': file.fileBytes,
        'replyId': replyTo?.id,
        'fileName': file.path
      };

      final fakeChat = Chat.detectChatModelType({
        'text': chatController.text,
        'id': room.chatList.isNotEmpty
            ? (room.chatList.last.chatNumberId! + 1)
            : 1,
        'fakeFile': file.fileBytes,
        'type': file.type,
        'room': room.id,
        'user': auth?.myUser?.toSaveFormat(),
        'deleted': false,
        'utcDate': DateTime.now().toUtc().toString(),
        'edited': false,
        'replyId': replyTo?.toSaveFormat(),
        '__v': 0
      });
      fakeChat.sendSuccessfully = false;

      room.chatList.add(fakeChat);
      notifyListeners();

      if (selectedRoom == room) {
        /// if we are at end of the list then scroll to received new chat
        if ((selectedRoom == room &&
                (maxIndexOfChatListOnViewPort - room.chatList.length).abs() <=
                    5) ||
            (selectedRoom == room && fakeChat.user!.id == auth!.myUser!.id)) {
          itemScrollController.scrollTo(
              index: room.chatList.length - 1,
              alignment: 0.1,
              duration: const Duration(milliseconds: 1000));
        }
      }

      if (i == sendFiles.length - 1) {
        chatController.clear();
        clearPreSendAttachment();
      }

      socket.emitWithAck('sendFile', data, ack: (data) {
        if (kDebugMode) {
          print("socket.emitWithAck('sendFile', $data);");
        }

        if (data['success']) {
          // room.chatList.remove(fakeChat);
          // notifyListeners();

          _receiveChatEvent(data, fakeChat);
        } else {
          Utils.showSnack(navigatorKey.currentContext!, data['msg']);
        }
      });
    }
  }

  final recordVoice = Record();

  void recordStart() async {
    if (showSendChat == false && showPreUploadFile == false) {
      // Check and request permission
      Directory appDocDir;
      if (kIsWeb) {
        appDocDir = Directory('/');
      } else {
        appDocDir = await getApplicationDocumentsDirectory();
      }
      var hasPermission = await recordVoice.hasPermission();
      if (hasPermission) {
        // Start recording

        var _voicePath =
            '${appDocDir.path}/audio_${DateFormat('yyyy_MM_dd_kk_mm_ss').format(DateTime.now())}.m4a';
        if (await recordVoice.hasPermission()) {
          await recordVoice
              .start(
            path: _voicePath,
            encoder: AudioEncoder.aacLc, // by default
            bitRate: 128000, // by default
          )
              .onError((error, stackTrace) {
            if (kDebugMode) {
              print('recordStop');
            }
          });
        } else {}
      }
    }
  }

  void recordStop(BuildContext context, Room room) {
    if (kDebugMode) {
      print('recordStop');
    }
    if (showSendChat) {
      return;
    }
    recordVoice.isRecording().then((isRecording) async {
      if (isRecording) {
        final name = await recordVoice.stop();
        if (name != null) {
          if (kDebugMode) {
            print('saved voice location is: ' + name);
          }
          if (kIsWeb) {
            final res = await http.get(Uri.parse(name));
            preSendAttachment(Uint8List.fromList(res.bodyBytes),
                type: 'voice', name: 'voice.m4a');
          } else {
            preSendAttachment(File(name).readAsBytesSync(),
                type: 'voice', name: name);
          }
        }
      }
    });
  }

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
    if (selectedRoom == room) {
      return;
    }

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

    try {
      if (data['success']) {
        final roomId = data['roomId'];
        final indexOfRoom = rooms.indexWhere((element) => element.id == roomId);
        if (indexOfRoom == -1) {
          /// todo : check exist list before add data
        }
        rooms[indexOfRoom]
            .chatList
            .addAll(Chat.getChatsFromJsonList(data['chats']));

        setConnectionStatus = null;
        notifyListeners();

        /// save chats
        _hiveManager.saveChats(
            rooms[indexOfRoom].chatList, rooms[indexOfRoom].id!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('userRoomChats exception: $e');
      }
    }
  }

  void _userRoomsEvent(data) async {
    if (kDebugMode) {
      print('userRooms => $data');
    }
    try {
      if (data['success']) {
        final _rooms = data['rooms'] as List;
        setConnectionStatus = _rooms.isNotEmpty ? 'Updating ...' : null;
        for (Map room in _rooms) {
          if (rooms.where((element) => element.id == room['_id']).isEmpty) {
            rooms.add(Room.fromJson(room, false));
          }
        }

        rooms.sort((a, b) => b.changeAt!.compareTo(b.changeAt!));
        notifyListeners();
        if (_rooms.isNotEmpty) {
          auth!.setLastGroupLoadedDate(rooms[0].changeAt!.toUtc().toString());
          _hiveManager.saveRooms(rooms);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('userRooms exception $e');
      }
    }
  }

  void _receiveChatEvent(data, [Chat? fakeChat]) async {
    if (kDebugMode) {
      print('receiveChat => $data');
      print("_receiveChatEvent(data, [Chat? $fakeChat])");
    }
    final chat = Chat.detectChatModelType(data['chat']);

    int indexOfRoom = rooms.indexWhere((element) => element.id == chat.room);

    /// add the room to the local list if not exist
    if (indexOfRoom == -1) {
      /// request to get room details
      /// or insert from chat `room` property
      Room room = Room.fromJson(data['room'], false);

      rooms.add(room);

      /// after get room, update ``indexOfRoom``
      indexOfRoom = rooms.indexOf(room);
    }

    /// get targetRoom from local list
    Room targetRoom = rooms[indexOfRoom];
    if (targetRoom.id == selectedRoom?.id) {
      selectedRoom = targetRoom;
    }

    if (fakeChat == null) {
      /// check last chat of the target room
      if (targetRoom.lastChat == null) {
        targetRoom.lastChat = chat;

        targetRoom.chatList.add(chat);
      } else {
        /// if received new (chat number id) - 1 is room lastChat of
        /// `loaded` chat list number id
        /// then we reached to end of the chat list
        /// that means we won't load more of list
        if (chat.chatNumberId! - 1 ==
                targetRoom
                    .chatList[targetRoom.chatList.length - 1].chatNumberId ||
            targetRoom.reachedToEnd) {
          targetRoom.chatList.add(chat);
        } else if (chat.user!.id == auth!.myUser!.id &&
            !targetRoom.reachedToEnd) {
          /// get the last 50 chats of the room if
          /// the sender user is from our account
          /// and we not reached to the end of target list
          targetRoom.chatList.clear();
          notifyListeners();

          socket.emitWithAck('loadMorePrevious',
              jsonEncode({'before': chat.chatNumberId, 'room': targetRoom.id}),
              ack: (data) {
            data = jsonDecode(data);
            if (data['success']) {
              final chatList = data['chats'] as List;
              targetRoom.chatList =
                  chatList.map((e) => Chat.detectChatModelType(e)).toList();
              targetRoom.chatList.add(chat);
              targetRoom.chatList
                  .sort((a, b) => a.chatNumberId!.compareTo(b.chatNumberId!));

              /// after add chat to chat list of the target room then
              /// save chat
              _hiveManager.saveChats(targetRoom.chatList, targetRoom.id!,
                  clearSavedList: true);
            } else {
              Utils.showSnack(navigatorKey.currentContext!, data['msg']);
            }
          });
        }
      }
    } else {
      final indexOfOldChat = targetRoom.chatList.indexOf(fakeChat);
      if (indexOfOldChat != -1) {
        targetRoom.chatList[indexOfOldChat] = chat;
      } else {
        targetRoom.chatList.add(chat);
      }
    }

    //

    /// after add chat to chat list of the target room then
    /// save chat
    _hiveManager.saveChats([chat], targetRoom.id!);

    /// else just update the last chat of list
    targetRoom.lastChat = chat;
    targetRoom.changeAt = chat.utcDate;
    notifyListeners();

    _hiveManager.updateRoom(targetRoom);
    auth!.setLastGroupLoadedDate(targetRoom.changeAt.toString());

    rooms.sort((a, b) => b.changeAt!.compareTo(a.changeAt!));

    /// if we are at end of the list then scroll to received new chat
    if (selectedRoom == targetRoom) {
      if ((maxIndexOfChatListOnViewPort - targetRoom.chatList.length).abs() <=
              3 ||
          chat.user!.id == auth!.myUser!.id) {
        if (maxIndexOfChatListOnViewPort !=
            ((selectedRoom?.chatList.length ?? -1) - 1)) {
          itemScrollController.scrollTo(
              index: targetRoom.chatList.length - 1,
              alignment: 0.1,
              duration: const Duration(milliseconds: 1000));
        }
      }
    }
    // try {
    //
    // } catch (e) {
    //   if (kDebugMode) {
    //     print(e);
    //   }
    // }
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
        print('exception #0001 $e');
      }
    }
  }

  void getAllRooms() async {
    rooms = await _hiveManager.getAllRooms();
    rooms.sort((a, b) => b.changeAt!.compareTo(a.changeAt!));
    notifyListeners();
    for (var room in rooms) {
      await getRoomChatsFromDatabase(room);
    }
    notifyListeners();
  }

  void clearRoomsList() async {
    await _hiveManager.clearRooms();
  }

  Future<void> getRoomChatsFromDatabase(Room room) async {
    await _hiveManager
        .getAllChatsOf(room)
        .then((value) => {room.chatList = value, notifyListeners()});
  }

  Future<void> _loadMoreNext() async {
    // if(loadingLoadMoreNext){
    //   return;
    // }

    loadingLoadMoreNext = true;
    notifyListeners();

    socket.emitWithAck(
        'loadMoreNext',
        jsonEncode(
            {'room': selectedRoom?.id, 'after': selectedRoom?.lastIndex}),
        ack: (res) {
      if (kDebugMode) {
        print('_loadMoreNext res : $res');
      }
      res = jsonDecode(res);
      loadingLoadMoreNext = false;
      if (res['success']) {
        List<Chat> _receivedChats = [];
        for (var item in res['chats']) {
          final chat = Chat.detectChatModelType(item);
          if (selectedRoom!.chatList
              .where((element) => element.id == chat.id)
              .isEmpty) {
            _receivedChats.add(chat);
            selectedRoom!.chatList.add(chat);
          }
        }
        if (_receivedChats.isEmpty) {
          selectedRoom!.reachedToEnd = true;
        } else {
          _hiveManager.saveChats(_receivedChats, selectedRoom!.id!);
        }
      }
      notifyListeners();
    });
    // selectedRoom.chatList
    // .
  }

  void _loadMorePrevious() {
    loadingLoadMorePrevious = true;
    notifyListeners();

    socket.emitWithAck(
        'loadMorePrevious',
        jsonEncode({
          'room': selectedRoom?.id,
          'before': selectedRoom?.chatList.first.chatNumberId
        }), ack: (res) {
      res = jsonDecode(res);
      loadingLoadMorePrevious = false;
      if (res['success']) {
        List<Chat> _receivedChats = [];
        for (var item in res['chats']) {
          _receivedChats.add(Chat.detectChatModelType(item));
        }
        if (_receivedChats.isEmpty) {
          selectedRoom!.reachedToStart = true;
        }
        selectedRoom!.chatList.addAll(_receivedChats);
        selectedRoom!.chatList
            .sort((a, b) => a.chatNumberId!.compareTo(b.chatNumberId!));
        _hiveManager.saveChats(_receivedChats, selectedRoom!.id!);
      }
      notifyListeners();
    });
  }

  Future<void> clearDatabase() async => await _hiveManager.clear();

  // Future sendFile(Uint8List bytes) async {
  //   Chat chat = Chat()
  //     ..fileUrl = bytes.toString()
  //     ..type = ChatType.photo
  //     ..user = auth?.myUser;
  //   selectedRoom?.chatList.add(chat);
  //   notifyListeners();
  // }

  void refreshPage(Room room) async {
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

  Future downloadFile(String url, String savePath, chat) async {
    if (chat is ChatVoiceModel || chat is ChatDocModel) {
      try {
        Response response = await Dio().get(
          url,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              chat.downloadProgress =
                  double.tryParse((received / total * 100).toStringAsFixed(2));
              notifyListeners();
            }
          },
          //Received data with List<int>
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! == 200;
              }),
        );
        File file = File(savePath);
        var raf = file.openSync(mode: FileMode.write);
        // response.data is List<int> type
        print('savePath is $savePath');
        raf.writeFromSync(response.data);
        await raf.close();
      } catch (e) {
        if (kDebugMode) {
          print('exception #002 $e');
        }
      }
    }
  }

  Future<bool> onWillPopChatPage(BuildContext context) async {
    if (showSticker ||
        showEmoji ||
        showShareFile ||
        MediaQuery.of(context).viewInsets.bottom > 0 ||
        showPreUploadFile) {
      showSticker = false;
      showShareFile = false;
      showEmoji = false;
      if (showPreUploadFile) {
        clearPreSendAttachment();
      }
      chatFocusNode.unfocus(disposition: UnfocusDisposition.scope);
      notifyListeners();
      return false;
    }
    if (selectedRoom != null) {
      saveLastViewPortSeenIndex(selectedRoom!);
      selectedRoom = null;
    }
    return true;
  }

  void clearPreSendAttachment() {
    preUploadFiles.clear();
    showPreUploadFile = false;
    notifyListeners();
  }

  void preSendAttachment(dynamic files, {required String type, String? name}) {
    showPreUploadFile = true;
    showShareFile = false;
    if (files is FilePickerResult) {
      for (var file in files.files) {
        if (kIsWeb) {
          preUploadFiles.add(UploadFileModel(
              type: type, fileBytes: file.bytes!, path: file.name));
        } else {
          preUploadFiles.add(
            UploadFileModel(
              type: type,
              fileBytes: File(file.path!).readAsBytesSync(),
              path: file.name,
            ),
          );
        }
      }
    } else if (files is XFile) {
      preUploadFiles.add(UploadFileModel(
          type: type,
          fileBytes: File(files.path).readAsBytesSync(),
          path: files.name));
    } else if (files is Uint8List) {
      preUploadFiles
          .add(UploadFileModel(type: type, fileBytes: files, path: name!));
    }
    notifyListeners();
  }

  void emitChat(Room room) {
    if (showPreUploadFile) {
      emitFile(room);
      return;
    } else if (showSendChat) {
      emitText(room);
      return;
    }
  }

  void enableChatReply(int index) {
    replyTo = selectedRoom?.chatList[index];
    notifyListeners();
  }

  void clearChatReply() {
    replyTo = null;
    notifyListeners();
  }

  bool sentOnceFirebaseToken = false,
      checkedOnceUpdate = false,
      updateAvailable = false;

  void _sendOnceFirebaseToken() {
    if (sentOnceFirebaseToken) {
      return;
    }

    try{

      FirebaseManager.firebaseToken(
          validKey:
          'BEOJb0aM5gE-_c8ro6-c1SrOQGF7NzTAbDylWNh1C82pP4oTYImJxzL_ZENcIMvuHEjvX8L_jJxR07JkK3PmC34')
          .then((value) {
        socket.emitWithAck('firebaseToken', value, ack: (res) {
          if (kDebugMode) {
            print('socket.emitWithAck firebaseToken res is $res');
          }
        });
        sentOnceFirebaseToken = true;
      });
    }catch(e){
      if (kDebugMode) {
        print('FirebaseManager.firebaseToken exception $e');
      }
    }
  }

  void _checkOnceUpdate() async {
    if (checkedOnceUpdate) {
      return;
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    if (kDebugMode) {
      print('==================================');
      print('appName : $appName');
      print('packageName : $packageName');
      print('version : $version');
      print('buildNumber : $buildNumber');
      print('==================================');
    }

    socket.emitWithAck('checkUpdate', buildNumber, ack: (updateAvailable) {
      checkedOnceUpdate = true;
      if (updateAvailable) {
        this.updateAvailable = true;
        notifyListeners();
      }
    });
  }

  void emitAction(type, value){
    socket.emitWithAck('action', {'type' : type ,'value' : value}, ack: (data) {
     _actionEvent(data);
    });
  }

  _actionEvent(data) async{
    if (kDebugMode) {
      print('_actionEvent $data');
    }
    if(data['success']){
      if(data['type'] == 'deleteChat'){
        final indexOfRoom = rooms.indexWhere((element) => element.id == data['room']);
        if(indexOfRoom != -1){
          final room = rooms[indexOfRoom];
          await _hiveManager.deleteChat(data['chat'],room);
          notifyListeners();
        }
      }
    }else{
      Utils.showSnack(navigatorKey.currentContext!, data['msg']);
    }
  }

  bool showSearchRoomsBox = false;

  List<Room>? roomsFromSearch;

  checkSearchMode() {
    showSearchRoomsBox = !showSearchRoomsBox;
    notifyListeners();
  }

  void findRooms(String content) {
    if(content.isEmpty){
      roomsFromSearch = null;
    }else{
      roomsFromSearch = rooms.where((element) => element.roomName == content).toList();
    }
    notifyListeners();
  }
}
