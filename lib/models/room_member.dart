import 'package:chat_babakcode/models/user.dart';

import 'app_collection.dart';

class RoomMember extends AppCollections {
  User? user;
  String? role;
  bool? restrictedByAdmin;
  bool? leftGroup;

  RoomMember();

  factory RoomMember.fromJson(Map json) {
    return RoomMember()
      ..user = User.fromJson(json['user'])
      ..role = json['role']
      ..restrictedByAdmin = json['restrictedByAdmin']
      ..leftGroup = json['leftGroup'];
  }

  @override
  Map<String, dynamic> toSaveFormat() => {
    'user': user!.toSaveFormat(),
    'role': role,
    'restrictedByAdmin': restrictedByAdmin,
    'leftGroup': leftGroup,
  };
}