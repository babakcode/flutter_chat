import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../models/room.dart';
import '../models/user.dart';
import '../services/request_manager.dart';
import '/main.dart';
import '/models/model_user.dart';

class SearchUserProvider extends ChangeNotifier {
  String? atSign;
  bool loading = false;

  TextEditingController userSearchTextEditController = TextEditingController();

  List<User> get usersList => _usersList;
  List<User> _usersList = [];

  int _selectedSearchUserWayIndex = 0;

  int get selectedSearchUserWayIndex => _selectedSearchUserWayIndex;
  List<String> searchWayList = ['token', 'user id'];

  set setIndexSelectedSearchUserWay(int index) {
    _selectedSearchUserWayIndex = index;
    notifyListeners();
  }

  Future<List<User>> getUsers() async {
    if (loading) {
      return [];
    }
    loading = true;

    // var response = await RequestManager
    //     .post('/searchUsers', data: {'username': atSign!.replaceAll('@', '').replaceAll(' ', '')},headers: {
    //   'token': navigatorKey.currentContext?.read<LoginProvider>().modelUser?.token ?? ''
    // });
    // loading = false;

    // if (response.statusCode == 200) {
    //   if (response.data['result']) {
    //     return (response.data['data'] as List)
    //         .map((e) => ModelUser.fromData(e))
    //         .toList();
    //   }
    // }
    return [];
  }

  void onDetectionFinished() {
    atSign = null;
    loading = false;
    notifyListeners();
  }

  void onDetectionTyped(String value) async {
    print(value);
    atSign = value;
    _usersList = await getUsers();
    notifyListeners();
  }

  //
  // ChatProvider
  // ? chatProvider;
  // initAuth(ChatProvider chatProvider) => this.chatProvider = chatProvider;
  //

  searchUserWith(BuildContext context) {
    String? searchData = userSearchTextEditController.text;
    if (searchWayList.isEmpty) {
      return;
    }
    loading = true;
    notifyListeners();

    final chatProvider = context.read<ChatProvider>();
    if (searchWayList[selectedSearchUserWayIndex] == searchWayList[0]) {
      //token

      chatProvider.rooms.where((element) => element.roomType == RoomType.pvUser).toList().forEach((room) {
        if(room.members!.where((element) => element.user!.publicToken == searchData).isNotEmpty){
          print('room find without request');
          chatProvider.selectedRoom = room;
          return;
        }
      });

    }

    // chatProvider.socket.emitWithAck(
    //   'searchRoom',
    //   {
    //     'roomType': 'pvUser',
    //     'searchText': searchData,
    //     'searchType': searchWayList[selectedSearchUserWayIndex]
    //   },
    //   ack: (data) {
    //     if (kDebugMode) {
    //       print(data);
    //     }
    //
    //     if (data['success']) {
    //       chatProvider.selectedRoom = Room.fromJson(data['room']);
    //
    //       if (GlobalSettingProvider.isPhonePortraitSize) {
    //         Navigator.push(
    //           navigatorKey.currentContext!,
    //           CupertinoPageRoute(
    //             builder: (context) => const ChatPage(),
    //           ),
    //         );
    //       } else {
    //         notifyListeners();
    //       }
    //     }
    //   },
    // );
  }
}
