import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import '../models/user.dart';
import '../ui/pages/chat/chat_page.dart';
import 'global_setting_provider.dart';

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
    atSign = value;
    _usersList = await getUsers();
    notifyListeners();
  }

  //
  // ChatProvider
  // ? chatProvider;
  // initAuth(ChatProvider chatProvider) => this.chatProvider = chatProvider;
  //

  void search(BuildContext context) {
    String? searchText = userSearchTextEditController.text;
    if (searchWayList.isEmpty) {
      return;
    }
    loading = true;
    notifyListeners();

    chatProvider?.searchRoom(
        // searchType: searchWayList[selectedSearchUserWayIndex],
        searchText: searchText,
        context: context,
        callBack: (Map data) {
          if(data['success']){

            loading = false;
            notifyListeners();

            final room = data['room'];
            chatProvider?.selectedRoom = room;
            Navigator.pop(context);
            Navigator.pop(context);

            if (GlobalSettingProvider.isPhonePortraitSize) {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const ChatPage(),
                  ));
            } else {
              notifyListeners();
              Future.delayed(const Duration(milliseconds: 100), () =>
              {chatProvider?.selectedRoom = room, chatProvider?.notifyListeners()},);
            }
            // if(data['findFromExistRoom']){
            //
            //   /// room found
            //
            //   if (GlobalSettingProvider.isPhonePortraitSize) {
            //     Navigator.push(
            //         context,
            //         CupertinoPageRoute(
            //           builder: (context) => const ChatPage(),
            //         ));
            //   } else {
            //     notifyListeners();
            //   }
            // }else{
            //
            //   selectedRoom = Room.fromJson(data['room'], false);
            //
            //   if (GlobalSettingProvider.isPhonePortraitSize) {
            //     Navigator.push(
            //       navigatorKey.currentContext!,
            //       CupertinoPageRoute(
            //         builder: (context) => const ChatPage(),
            //       ),
            //     );
            //   } else {
            //     notifyListeners();
            //   }
            // }

          }else{
            Utils.showSnack( data['msg']);
          }
        });
  }
}
