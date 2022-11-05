import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class User extends HiveObject {

  @HiveField(0)
  String? id;
  // Hive fields go here
  @HiveField(1)
  String? publicToken;

  @HiveField(2)
  String? name;

  @HiveField(3)
  bool? isOnline;

  @HiveField(4)
  String? profileUrl;

  @HiveField(5)
  String? username;
  
  User();

  factory User.fromJson(json){
    return User()
    ..id = json['_id']
    ..publicToken = json['publicToken']
    ..name = json['name']
    ..username = json['username']
    ..isOnline = json['isOnline']
    ;
  }

  Map toMap() => {
    '_id': id,
    'publicToken': publicToken,
    'name': name,
    'isOnline': isOnline,
    'profileUrl': profileUrl,
  };
  
}