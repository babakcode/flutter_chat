
class User {

  String? id;
  // Hive fields go here
  String? publicToken;

  String? name;

  bool? isOnline;

  String? profileUrl;

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