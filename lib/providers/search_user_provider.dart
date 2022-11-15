import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_page.dart';
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
  ChatProvider? chatProvider;

  void initChatProvider(ChatProvider chatProvider) =>
      this.chatProvider = chatProvider;

  String? atSign;
  bool loading = false;

  TextEditingController userSearchTextEditController = TextEditingController();

  List<User> get usersList => _usersList;
  List<User> _usersList = [];

  int _selectedSearchUserWayIndex = 0;

  int get selectedSearchUserWayIndex => _selectedSearchUserWayIndex;
  List<String> searchWayList = ['token', 'username'];

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
    String? searchText = userSearchTextEditController.text;
    if (searchWayList.isEmpty) {
      return;
    }
    loading = true;
    notifyListeners();

    chatProvider?.searchRoomWith(
        roomType: 'pvUser',
        searchType: searchWayList[selectedSearchUserWayIndex],
        searchText: searchText,
        context: context,
        callBack: (Map data) {
          if(data['success']){
            loading = false;
            notifyListeners();
          }
        });
  }
}
