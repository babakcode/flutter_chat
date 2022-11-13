import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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

  Future<List<User>> getUsers() async {
    if(loading) {
      return[];
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
}
