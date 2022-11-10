import 'package:chat_babakcode/models/user.dart';

class RoomMember  {
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
}