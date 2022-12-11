import 'package:chat_babakcode/models/app_collection.dart';
import 'package:chat_babakcode/utils/hive_manager.dart';
// import 'package:hive/hive.dart';
//
// final _userBox = Hive.box('user');
HiveManager _hiveManager = HiveManager();
class User extends AppCollections{
  String? id;
  String? publicToken;
  String? name;
  bool? isOnline;
  String? profileUrl;
  String? username;
  int? version;

  User();

  factory User.fromJson(json) {

    if(json is String){
      json = _hiveManager.usersBox.get(json);
    }
    return User()
      ..id = json['_id']
      ..publicToken = json['publicToken']
      ..name = json['name']
      ..profileUrl = json['profileUrl']
      ..username = json['username']
      ..isOnline = json['isOnline']
      ..version = json['__v'];
  }

  //
  // User? findById(String id){
  //   final _find = _userBox.get(id);
  //   if(_find == null){
  //     return null;
  //   }
  //   return User.fromJson(_find);
  // }
  //
  // Future<void> save() async => await _userBox.put(id, toMap());
  // Future<void> saveMeany(List<Map> list) async {
  //   for(var item in list){
  //     await _userBox.put(item['_id'], item);
  //   }
  // }
  // Future<void> saveMeanyUser(List<User> list) async {
  //   for(var item in list){
  //     await _userBox.put(item.id, item.toMap());
  //   }
  // }


  @override
  Map<String, dynamic> toSaveFormat() => {
    '_id': id,
    'publicToken': publicToken,
    'name': name,
    'isOnline': isOnline,
    'profileUrl': profileUrl,
    'username': username,
    '__v': version,
  };
}
