// import 'package:chat_babakcode/models/model_user.dart';
// import 'package:intl/intl.dart';
// import '/models/chat_model.dart';

// enum RoomType{
//   pvUser, publicGroup, pvGroup, channel
// }

// class ModelRoom {
//   String id;
//   String ownerId;
//   String roomName;
//   RoomType roomType;
//   DateTime changeAt;
//   DateTime createAt;
//   bool deleted;
//   List<ChatModel> chats;
//   List<ModelRoomMember> members;
//   bool isLastRequestMessage = false;

//   ModelRoom(
//       {required this.id,
//       required this.ownerId,
//       required this.createAt,
//       required this.patientGender,
//       required this.age,
//       required this.chiefComplane,
//       required this.lastChat,
//       required this.patientName,
//       required this.chatEnded,
//       required this.listChat
//       });

//   factory ModelRoom.fromData(data) {
//     // List<ChatModel?> list = (data['chats'] as List).map((chat) {
//     //   switch(chat['type']){
//     //     case 'TEXT' :
//     //       return ChatTextModel.fromJson(chat);
//     //   }
//     // } ).toList();

//     DateTime dateT = DateTime.parse(data['date']);
//     var dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateT.toString(),true);
//     DateTime dateLocal = dateTime.toLocal();

//     return ModelRoom(
//         id: data['_id'],
//         ownerId: data['ownerId'],
//         patientName: data['patientName'],
//         chatEnded: data['chatEnded'],

//         date: dateLocal,
//         patientGender: data['patientGender'],
//         age: data['age'],
//         chiefComplane: data['chiefComplane'],
//         lastChat: data['lastChat'],
//         listChat: (data['chats'] as List)
//             .map((chat) => ChatModel.detectChatModelType(chat))
//             .toList());
//   }
// }


// class ModelRoomMember{
//   ModelUser? user;
//   String? rool;
//   bool? restrictedByAdmin;
//   bool? leftGroup;
// }