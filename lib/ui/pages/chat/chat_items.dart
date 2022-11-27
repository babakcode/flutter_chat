part of './app_text_item.dart';




//
//
// Widget _itemVoice(BuildContext context, bool fromMyAccount, int index) {
//   final globalSettingProvider = context.read<GlobalSettingProvider>();
//   final auth = context.read<Auth>();
//   final chatProvider = context.read<ChatProvider>();
//
//   final Room room = chatProvider.selectedRoom!;
//   Chat chat = room.chatList[index];
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     crossAxisAlignment:
//         fromMyAccount ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//     children: [
//
//       Flexible(
//         child: Card(
//           margin: const EdgeInsets.all(6),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Column(
//               crossAxisAlignment:
//               chat.user!.id == auth.myUser!.id
//                   ? CrossAxisAlignment.end
//                   : CrossAxisAlignment.start,
//               children: [
//                 Text(chat.user!.name!,
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                   maxLines: 1,
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 SizedBox(
//                   width: 270,
//                   child: Row(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.grey.shade50,
//                         ),
//                         child: FutureBuilder<Directory>(
//                             future: getApplicationDocumentsDirectory(),
//                             builder: (context, snapshot) {
//                               if (snapshot.hasData) {
//                                 String fullPath =
//                                     "${snapshot.data!.path}/${chat.fileUrl}";
//                                 bool exist = File(fullPath).existsSync();
//                                 return Consumer<ChatProvider>(
//                                     builder: (context, chatProvider, child) {
//                                       if (chatVoiceModel.downloadProgress !=
//                                           null &&
//                                           chatVoiceModel.downloadProgress! < 99) {
//                                         return CircularProgressIndicator(
//                                           value:
//                                           chatVoiceModel.downloadProgress! /
//                                               100,
//                                         );
//                                       }
//                                       return IconButton(
//                                         onPressed: () async {
//                                           if (exist == false) {
//                                             chatProvider.downloadImage(
//                                                 '/${chatVoiceModel.fileUrl}',
//                                                 fullPath,
//                                                 chatVoiceModel);
//                                           } else {
//                                             chatVoiceModel.isPlaying = true;
//                                             chatProvider.notifyListeners();
//                                             await chatVoiceModel.audioPlayer
//                                                 .setFilePath(fullPath);
//                                             await chatVoiceModel.audioPlayer
//                                                 .play();
//                                             await chatVoiceModel.audioPlayer
//                                                 .pause();
//                                             chatVoiceModel.isPlaying = false;
//                                             chatProvider.notifyListeners();
//                                           }
//                                         },
//                                         icon: exist
//                                             ? chatVoiceModel.isPlaying
//                                             ? const Icon(Icons.pause)
//                                             : const Icon(Icons.play_arrow)
//                                             : const Icon(Icons.download),
//                                       );
//                                     });
//                               }
//                               return const CircularProgressIndicator();
//                             }),
//                       ),
//                       Expanded(
//                           child: Text(
//                             chatVoiceModel.fileUrl ?? '',
//                             maxLines: 1,
//                           ))
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 Text(
//                   intl.DateFormat('HH:mm')
//                       .format(chatVoiceModel.date!)
//                       .toString(),
//                   style: const TextStyle(fontSize: 12),
//                 )
//               ],
//             ),
//           ),
//           color: chatVoiceModel.user!.id == loginProvider.modelUser?.id
//               ? AppConstants.redAccentChatHomeColor
//               : Colors.white,
//         ),
//       ),
//       // Text(
//       //   chat.text ?? '',
//       //   style: TextStyle(
//       //       color: globalSettingProvider.isDarkTheme
//       //           ? fromMyAccount
//       //               ? AppConstants.textColor[200]
//       //               : AppConstants.textColor[700]
//       //           : AppConstants.textColor[700]),
//       // ),
//       Text(
//         intl.DateFormat('HH:mm').format(chat.utcDate ?? DateTime.now()),
//         style: TextStyle(
//             fontSize: 12,
//             color: globalSettingProvider.isDarkTheme
//                 ? fromMyAccount
//                     ? AppConstants.textColor[200]
//                     : AppConstants.textColor[700]
//                 : AppConstants.textColor[700]),
//       )
//     ],
//   );
// }


