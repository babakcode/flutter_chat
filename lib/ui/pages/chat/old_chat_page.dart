// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
// import 'package:detectable_text_field/widgets/detectable_text_field.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:shamsi_date/shamsi_date.dart';
// import '/models/chat_model.dart';
// import '/models/model_patient.dart';
// import '/models/model_user.dart';
// import '/providers/login_provider.dart';
// import '/providers/search_user_provider.dart';
// import '/ui/pages/profile/display_profile.dart';
// import '/ui/pages/zoom_image/zoom_image_page.dart';
// import 'package:intl/intl.dart' as intl;
// import '../../../services/request_manager.dart';
// import '../../../providers/chat_provider.dart';

// class ChatPage extends StatefulWidget {
//   final ModelPatient modelPatient;

//   const ChatPage({Key? key, required this.modelPatient}) : super(key: key);

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   ChatProvider? chatProvider;

//   @override
//   void dispose() {
//     chatProvider?.setWeAreInThisGroup = null;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     chatProvider = Provider.of(context);
//     final loginProvider = context.read<LoginProvider>();
//     final searchAtSignUserProvider = context.read<SearchAtSignUserProvider>();

//     final j = widget.modelPatient.date.toJalali();
//     final date3 = intl.DateFormat('HH:mm').format(widget.modelPatient.date);

//     return Scaffold(
//       appBar: AppBar(
//         title: InkWell(
//           onTap: () {
//             showDialog(
//               context: context,
//               builder: (context) => Dialog(
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Directionality(
//                     textDirection: TextDirection.rtl,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         ListTile(
//                           title: Text(
//                               "نام و نام خانوادگی بیمار: ${widget.modelPatient.patientName}"),
//                         ),
//                         ListTile(
//                             title: Text(
//                                 "کد بیمار: ${widget.modelPatient.patientCode}")),
//                         ListTile(
//                             title:
//                                 Text("سن بیمار : ${widget.modelPatient.age}")),
//                         ListTile(
//                           title: Text(
//                               "جنسیت بیمار : ${widget.modelPatient.patientGender}"),
//                         ),
//                         ListTile(
//                             title: Text(
//                                 "تاریخ درخواست : ${j.year}/${j.month}/${j.day}")),
//                         ListTile(title: Text("ساعت درخواست : $date3")),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//           child: Row(
//             children: [
//               Text(widget.modelPatient.patientCode),
//             ],
//           ),
//         ),
//         actions: [
//           PopupMenuButton<int>(
//               // Callback that sets the selected popup menu item.
//               onSelected: (int? item) async {
//                 switch (item) {
//                   case 1:
//                     {
//                       showDialog(
//                         context: context,
//                         builder: (context) => Dialog(
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Text("آیا از ترخیص بیمار مطمئن هستید؟"),
//                               Row(
//                                 children: [
//                                   MaterialButton(
//                                     onPressed: () async {
//                                       chatProvider!.changeStatusGroup(
//                                           widget.modelPatient);
//                                       Navigator.pop(context);
//                                       // disable chat
//                                     },
//                                     child: const Text("بله مطمئن هستم"),
//                                   ),
//                                   MaterialButton(
//                                     onPressed: () => Navigator.pop(context),
//                                     child: const Text("خیر"),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       );
//                       break;
//                     }
//                 }
//               },
//               itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
//                     PopupMenuItem(
//                       value: 1,
//                       child: Text(!widget.modelPatient.chatEnded
//                           ? 'Discharge patient'
//                           : 'Charge patient'),
//                     ),
//                   ]),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: NotificationListener<ScrollNotification>(
//               onNotification: (ScrollNotification scrollInfo) {
//                 if (scrollInfo.metrics.pixels ==
//                     scrollInfo.metrics.maxScrollExtent) {
//                   chatProvider!.loadMoreMessage(
//                       context: context, modelPatient: widget.modelPatient);
//                 }
//                 return false;
//               },
//               child: SingleChildScrollView(
//                 reverse: true,
//                 child: Column(
//                   children: [
//                     if (!widget.modelPatient.isLastRequestMessage &&
//                         widget.modelPatient.listChat.length > 50)
//                       const CircularProgressIndicator(),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: widget.modelPatient.listChat.length,
//                       itemBuilder: (context, index) {
//                         var item = widget.modelPatient.listChat[index];
//                         var lastUserChat = widget.modelPatient.listChat
//                             .lastWhere(
//                                 (element) => element.user!.id == item.user!.id);
//                         if (item != lastUserChat) {
//                           item.user = lastUserChat.user;
//                         }

//                         if (item is ChatTextModel) {
//                           return Container(
//                               width: MediaQuery.of(context).size.width,
//                               alignment:
//                                   item.user!.id == loginProvider.modelUser?.id
//                                       ? Alignment.centerRight
//                                       : Alignment.centerLeft,
//                               child: itemChatText(
//                                   context,
//                                   widget.modelPatient.listChat[index]
//                                       as ChatTextModel));
//                         } else if (item is ChatImageModel) {
//                           return Container(
//                               width: MediaQuery.of(context).size.width,
//                               alignment:
//                                   item.user!.id == loginProvider.modelUser?.id
//                                       ? Alignment.centerRight
//                                       : Alignment.centerLeft,
//                               child: itemChatImage(context, item));
//                         } else if (item is ChatStickerModel) {
//                           return Container(
//                               width: MediaQuery.of(context).size.width,
//                               alignment:
//                                   item.user!.id == loginProvider.modelUser?.id
//                                       ? Alignment.centerRight
//                                       : Alignment.centerLeft,
//                               child: itemChatSticker(context, item));
//                         } else if (item is ChatConsultationFormModel) {
//                           return Container(
//                               width: MediaQuery.of(context).size.width,
//                               alignment:
//                                   item.user!.id == loginProvider.modelUser?.id
//                                       ? Alignment.centerRight
//                                       : Alignment.centerLeft,
//                               child: itemChatConsultation(context, item));
//                         } else if (item is ChatPatientInfoFormModel) {
//                           return Container(
//                               width: MediaQuery.of(context).size.width,
//                               alignment:
//                                   item.user!.id == loginProvider.modelUser?.id
//                                       ? Alignment.centerRight
//                                       : Alignment.centerLeft,
//                               child: itemChatPatientInfo(context, item));
//                         } else if (item is ChatVoiceModel) {
//                           return Container(
//                               width: MediaQuery.of(context).size.width,
//                               alignment:
//                                   item.user!.id == loginProvider.modelUser?.id
//                                       ? Alignment.centerRight
//                                       : Alignment.centerLeft,
//                               child: itemChatVoice(context, item));
//                         } else if (item is ChatUpdateRequireModel) {
//                           return Container(
//                               width: MediaQuery.of(context).size.width,
//                               alignment:
//                                   item.user!.id == loginProvider.modelUser?.id
//                                       ? Alignment.centerRight
//                                       : Alignment.centerLeft,
//                               child: itemUpdateRequireChat(
//                                   context,
//                                   widget.modelPatient.listChat[index]
//                                       as ChatUpdateRequireModel));
//                         } else if (item is ChatFileFormModel) {
//                           return Container(
//                               width: MediaQuery.of(context).size.width,
//                               alignment:
//                                   item.user!.id == loginProvider.modelUser?.id
//                                       ? Alignment.centerRight
//                                       : Alignment.centerLeft,
//                               child: itemChatFile(context, item));
//                         }
//                         return const Text("Update required");
//                       },
//                       physics: const NeverScrollableScrollPhysics(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           widget.modelPatient.chatEnded
//               ? Card(
//                   margin: EdgeInsets.zero,
//                   child: const Center(
//                     child: Padding(
//                       padding: EdgeInsets.all(14.0),
//                       child: Text('Chat Ended'),
//                     ),
//                   ),
//                 )
//               : Column(children: [
//                   Consumer<SearchAtSignUserProvider>(
//                       builder: (_, searchSignProvider, __) {
//                     return searchSignProvider.atSign == null
//                         ? const SizedBox()
//                         : searchSignProvider.loading
//                             ? const Padding(
//                                 padding: EdgeInsets.all(12),
//                                 child: Center(
//                                   child: CircularProgressIndicator(),
//                                 ),
//                               )
//                             : Container(
//                                 constraints: const BoxConstraints(
//                                     maxHeight: 350, minHeight: 0),
//                                 child: ListView.builder(
//                                   shrinkWrap: true,
//                                   reverse: true,
//                                   itemBuilder: (context, index) {
//                                     ModelUser user =
//                                         searchSignProvider.usersList[index];
//                                     return ListTile(
//                                       onTap: () {
//                                         chatProvider!.chatController.text =
//                                             chatProvider!.chatController.text
//                                                 .replaceAll(
//                                                     searchSignProvider.atSign!,
//                                                     ' @${user.username} ');

//                                         searchSignProvider
//                                             .onDetectionFinished();
//                                       },
//                                       title: Text(user.username),
//                                       trailing: Text(user.fullName ?? 'guest'),
//                                     );
//                                   },
//                                   itemCount:
//                                       searchSignProvider.usersList.length,
//                                 ),
//                                 color: Colors.white,
//                               );
//                   }),
//                   Card(
//                     elevation: 0,
//                     color: Colors.grey[200],
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24)),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8.0, vertical: 4.0),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           IconButton(
//                               onPressed: () => chatProvider!.emojiToggle(),
//                               icon: const Icon(Icons.emoji_emotions_outlined)),
//                           AnimatedSize(
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.fastOutSlowIn,
//                             child: Container(
//                               child: chatProvider!.showSendChat
//                                   ? null
//                                   : IconButton(
//                                       onPressed: () =>
//                                           chatProvider!.stickerToggle(),
//                                       icon: const Icon(
//                                           Icons.emoji_food_beverage_outlined)),
//                             ),
//                           ),
//                           Expanded(
//                               child: DetectableTextField(
//                             detectionRegExp: detectionRegExp(
//                                 hashtag: false, atSign: true, url: true)!,
//                             minLines: 1,
//                             onDetectionFinished:
//                                 searchAtSignUserProvider.onDetectionFinished,
//                             onDetectionTyped:
//                                 searchAtSignUserProvider.onDetectionTyped,
//                             focusNode: chatProvider!.chatFocusNode,
//                             controller: chatProvider!.chatController,
//                             keyboardType: TextInputType.multiline,
//                             textInputAction: TextInputAction.newline,
//                             maxLines: 6,
//                             decoration: const InputDecoration(
//                                 hintText: "write a message",
//                                 border: InputBorder.none),
//                           )),
//                           AnimatedSwitcher(
//                             duration: const Duration(milliseconds: 300),
//                             child: chatProvider!.showSendChat
//                                 ? null
//                                 : IconButton(
//                                     onPressed: () {
//                                       chatProvider!.showForm();
//                                     },
//                                     icon: const Icon(Icons.add)),
//                           ),
//                           AnimatedSwitcher(
//                             duration: const Duration(milliseconds: 300),
//                             child: chatProvider!.showSendChat
//                                 ? null
//                                 : IconButton(
//                                     onPressed: () {
//                                       showDialog(
//                                           context: context,
//                                           builder: (c) {
//                                             return dialogSelectFile(c);
//                                           });
//                                     },
//                                     icon:
//                                         const Icon(Icons.attach_file_outlined)),
//                           ),
//                           Card(
//                             shape: const CircleBorder(),
//                             clipBehavior: Clip.antiAliasWithSaveLayer,
//                             child: GestureDetector(
//                               onTap: () {
//                                 if (chatProvider!.showSendChat) {
//                                   chatProvider!.sendChat(
//                                       context, widget.modelPatient.id);
//                                 }
//                               },
//                               onLongPress: () => chatProvider!.recordStart(),
//                               onLongPressEnd: (s) => chatProvider!
//                                   .recordStop(context, widget.modelPatient),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: AnimatedSwitcher(
//                                   duration: const Duration(milliseconds: 600),
//                                   child: Icon(chatProvider!.showSendChat
//                                       ? Icons.send
//                                       : Icons.keyboard_voice_rounded),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   Offstage(
//                     offstage: !chatProvider!.emojiShowing,
//                     child: SizedBox(
//                       height: 250,
//                       child: EmojiPicker(
//                           onEmojiSelected: (category, emoji) => chatProvider!.onEmojiSelected(emoji),
//                           onBackspacePressed: chatProvider!.onBackspacePressed,
//                           config: const Config(
//                               columns: 7,
//                               // Issue: https://github.com/flutter/flutter/issues/28894
//                               emojiSizeMax: 32,
//                               verticalSpacing: 0,
//                               horizontalSpacing: 0,
//                               initCategory: Category.RECENT,
//                               bgColor: Color(0xFFF2F2F2),
//                               indicatorColor: Colors.blue,
//                               iconColor: Colors.grey,
//                               iconColorSelected: Colors.blue,
//                               backspaceColor: Colors.blue,
//                               skinToneDialogBgColor: Colors.white,
//                               skinToneIndicatorColor: Colors.grey,
//                               enableSkinTones: true,
//                               showRecentsTab: true,
//                               recentsLimit: 28,
//                               // noRecentsText: 'No Recents',
//                               // noRecentsStyle:
//                               //     TextStyle(fontSize: 20, color: Colors.black26),
//                               tabIndicatorAnimDuration: kTabScrollDuration,
//                               categoryIcons: CategoryIcons(),
//                               buttonMode: ButtonMode.MATERIAL)),
//                     ),
//                   ),
//                   Offstage(
//                     offstage: !chatProvider!.formVisibility,
//                     child: SizedBox(
//                       height: 250,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () async {
//                                   await chatProvider!
//                                       .pickFile(context, widget.modelPatient);
//                                 },
//                                 child: Column(
//                                   children: [
//                                     Expanded(
//                                         child: Image.asset(
//                                             'assets/images/form_image_1.png')),
//                                     const Text('رادیولوژی'),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () async {
//                                   await chatProvider!
//                                       .pickFile(context, widget.modelPatient);
//                                 },
//                                 child: Column(
//                                   children: [
//                                     Expanded(
//                                         child: Image.asset(
//                                             'assets/images/form_image_2.jpg')),
//                                     const Text('ازمایشگاه'),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () {

//                                 },
//                                 child: Column(
//                                   children: [
//                                     Expanded(
//                                         child: Image.asset(
//                                             'assets/images/form_image_3.jpg')),
//                                     const Text('فرم مشاوره'),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: InkWell(
//                                 onTap: () {
  
//                                 },
//                                 child: Column(
//                                   children: [
//                                     Expanded(
//                                         child: Image.asset(
//                                             'assets/images/form_image_4.jpg')),
//                                     const Text('فرم شرح حال'),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Offstage(
//                     offstage: !chatProvider!.showSticker,
//                     child: SizedBox(
//                       height: 350,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: GridView.count(
//                             crossAxisCount: 3,
//                             children: List.generate(
//                                 9,
//                                 (index) => InkWell(
//                                       onTap: () {
//                                         chatProvider!.sendSticker(
//                                             groupId: widget.modelPatient.id,
//                                             context: context,
//                                             sticker: "${index + 1}");
//                                       },
//                                       child: Image.asset(
//                                           "assets/stickers/sticker${index + 1}.png"),
//                                     ))),
//                       ),
//                     ),
//                   ),
//                 ])
//         ],
//       ),
//     );
//   }

//   Widget itemChatText(BuildContext context, ChatTextModel chatTextModel) {
//     final loginProvider = context.read<LoginProvider>();
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (chatTextModel.user!.id != loginProvider.modelUser?.id)
//           Hero(
//             tag: chatTextModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: const CircleBorder(),
//                 child: chatTextModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatTextModel.user!,
//                                     tag: chatTextModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatTextModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//         Flexible(
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 260),
//             child: Card(
//               margin: const EdgeInsets.all(6),
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment:
//                       chatTextModel.user!.id == loginProvider.modelUser?.id
//                           ? CrossAxisAlignment.end
//                           : CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       chatTextModel.user!.fullName == ''
//                           ? 'کاربر مهمان'
//                           : chatTextModel.user!.fullName ?? 'کاربر مهمان',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     Text(chatTextModel.text ?? ''),
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     Text(
//                       intl.DateFormat('HH:mm')
//                           .format(chatTextModel.date!),
//                       style: const TextStyle(fontSize: 12),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         if (chatTextModel.user!.id == loginProvider.modelUser?.id)
//           Hero(
//             tag: chatTextModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: const CircleBorder(),
//                 child: chatTextModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatTextModel.user!,
//                                     tag: chatTextModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatTextModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget itemUpdateRequireChat(
//       BuildContext context, ChatUpdateRequireModel chatUpdateRequireModel) {
//     final loginProvider = context.read<LoginProvider>();
//     return Card(
//       child: const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: Text('update required!'),
//       ),
//       color: chatUpdateRequireModel.user!.id == loginProvider.modelUser?.id
//           ? Colors.grey[50]
//           : Colors.grey[300],
//     );
//   }

//   Widget itemChatFile(
//       BuildContext context, ChatFileFormModel chatFileFormModel) {
//     final loginProvider = context.read<LoginProvider>();
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (chatFileFormModel.user!.id != loginProvider.modelUser?.id)
//           Hero(
//             tag: chatFileFormModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: const CircleBorder(),
//                 child: chatFileFormModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatFileFormModel.user!,
//                                     tag: chatFileFormModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatFileFormModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//         Flexible(
//           child: Card(
//             clipBehavior: Clip.antiAliasWithSaveLayer,
//             margin: const EdgeInsets.all(6),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Column(
//                 crossAxisAlignment:
//                     chatFileFormModel.user!.id == loginProvider.modelUser?.id
//                         ? CrossAxisAlignment.end
//                         : CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4),
//                     child: Text(
//                       chatFileFormModel.user!.fullName == ''
//                           ? 'کاربر مهمان'
//                           : chatFileFormModel.user!.fullName ?? 'کاربر مهمان',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   FutureBuilder<Directory>(
//                       future: getTemporaryDirectory(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           String fullPath =
//                               "${snapshot.data!.path}/${chatFileFormModel.fileUrl}";
//                           bool exist = File(fullPath).existsSync();
//                           return InkWell(
//                             onTap: () {
//                               if (exist == false) {
//                                 context.read<ChatProvider>().downloadFile(
//                                     '/${chatFileFormModel.fileUrl}',
//                                     fullPath,
//                                     chatFileFormModel);
//                               } else {
//                                 OpenFile.open(fullPath);
//                               }
//                             },
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.grey.shade50,
//                                   ),
//                                   padding: const EdgeInsets.all(4),
//                                   child: Consumer<ChatProvider>(
//                                       builder: (context, chatProvider, child) {
//                                     if (chatFileFormModel.downloadProgress !=
//                                             null &&
//                                         chatFileFormModel.downloadProgress! <
//                                             99) {
//                                       return CircularProgressIndicator(
//                                         value: chatFileFormModel
//                                                 .downloadProgress! /
//                                             100,
//                                       );
//                                     }
//                                     return IconButton(
//                                       onPressed: () async {
//                                         if (exist == false) {
//                                           chatProvider.downloadFile(
//                                               '/${chatFileFormModel.fileUrl}',
//                                               fullPath,
//                                               chatFileFormModel);
//                                         } else {
//                                           OpenFile.open(fullPath);
//                                         }
//                                       },
//                                       icon: exist
//                                           ? const Icon(Icons.insert_drive_file)
//                                           : const Icon(Icons.download),
//                                     );
//                                   }),
//                                 ),
//                                 SizedBox(
//                                   child: Text(
//                                     chatFileFormModel.fileUrl ?? '',
//                                     maxLines: 1,
//                                   ),
//                                   width: 210,
//                                 )
//                               ],
//                             ),
//                           );
//                         }
//                         return const CircularProgressIndicator();
//                       }),
//                   const SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     intl.DateFormat('HH:mm')
//                         .format(chatFileFormModel.date!)
//                         .toString(),
//                     style: const TextStyle(fontSize: 12),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         if (chatFileFormModel.user!.id == loginProvider.modelUser?.id)
//           Hero(
//             tag: chatFileFormModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: const CircleBorder(),
//                 child: chatFileFormModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatFileFormModel.user!,
//                                     tag: chatFileFormModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatFileFormModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget itemChatImage(BuildContext context, ChatImageModel chatImageModel) {
//     final loginProvider = context.read<LoginProvider>();
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (chatImageModel.user!.id != loginProvider.modelUser?.id)
//           Hero(
//             tag: chatImageModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: const CircleBorder(),
//                 child: chatImageModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatImageModel.user!,
//                                     tag: chatImageModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatImageModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//         Card(
//           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
//           clipBehavior: Clip.antiAliasWithSaveLayer,
//           child: InkWell(
//             onTap: () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ZoomImagePage(
//                       imageUrl:
//                           '${RequestManager.baseUrl}/${chatImageModel.imageUrl}'),
//                 )),
//             child: Column(
//               crossAxisAlignment:
//                   chatImageModel.user!.id == loginProvider.modelUser?.id
//                       ? CrossAxisAlignment.end
//                       : CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
//                   child: Text(
//                     chatImageModel.user!.fullName == ''
//                         ? 'کاربر مهمان'
//                         : chatImageModel.user!.fullName ?? 'کاربر مهمان',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                     maxLines: 1,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 CachedNetworkImage(
//                   errorWidget: (context, error, stackTrace) {
//                     return const Center();
//                   },
//                   progressIndicatorBuilder: (context, url, downloadProgress) {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         value: downloadProgress.progress,
//                       ),
//                     );
//                   },
//                   imageUrl:
//                       '${RequestManager.baseUrl}/${chatImageModel.imageUrl}',
//                   width: 260,
//                   height: 320,
//                   fit: BoxFit.cover,
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 Text(
//                   intl.DateFormat('HH:mm')
//                       .format(chatImageModel.date!)
//                       .toString(),
//                   style: const TextStyle(fontSize: 12),
//                 )
//               ],
//             ),
//           ),
//         ),
//         if (chatImageModel.user!.id == loginProvider.modelUser?.id)
//           Hero(
//             tag: chatImageModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: const CircleBorder(),
//                 child: chatImageModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatImageModel.user!,
//                                     tag: chatImageModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatImageModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

// //
//   Widget itemChatSticker(
//       BuildContext context, ChatStickerModel chatStickerModel) {
//     final loginProvider = context.read<LoginProvider>();
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (chatStickerModel.user!.id != loginProvider.modelUser?.id)
//           Hero(
//             tag: chatStickerModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: const CircleBorder(),
//                 child: chatStickerModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatStickerModel.user!,
//                                     tag: chatStickerModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatStickerModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//         Flexible(
//           child: Card(
//             margin: const EdgeInsets.all(6),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Column(
//                 crossAxisAlignment:
//                     chatStickerModel.user!.id == loginProvider.modelUser?.id
//                         ? CrossAxisAlignment.end
//                         : CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     chatStickerModel.user!.fullName == ''
//                         ? 'کاربر مهمان'
//                         : chatStickerModel.user!.fullName ?? 'کاربر مهمان',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(
//                     height: 4,
//                   ),
//                   Image.asset(
//                     "assets/stickers/sticker${chatStickerModel.stickerId}.png",
//                   ),
//                   const SizedBox(
//                     height: 4,
//                   ),
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         intl.DateFormat('HH:mm')
//                             .format(chatStickerModel.date!)
//                             .toString(),
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                       const Text(
//                         ' | sticker',
//                         style: TextStyle(fontSize: 10),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         if (chatStickerModel.user!.id == loginProvider.modelUser?.id)
//           Hero(
//             tag: chatStickerModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: const CircleBorder(),
//                 child: chatStickerModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatStickerModel.user!,
//                                     tag: chatStickerModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatStickerModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

// //
//   Widget itemChatConsultation(BuildContext context,
//       ChatConsultationFormModel chatConsultationFormModel) {
//     final loginProvider = context.read<LoginProvider>();
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (chatConsultationFormModel.user!.id != loginProvider.modelUser?.id)
//           Hero(
//             tag: chatConsultationFormModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: const CircleBorder(),
//                 child: chatConsultationFormModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatConsultationFormModel.user!,
//                                     tag: chatConsultationFormModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatConsultationFormModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//         Flexible(
//           child: Card(

//             margin: const EdgeInsets.all(6),
//             child: InkWell(
//               onTap: () => {},
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: chatConsultationFormModel.user!.id ==
//                           loginProvider.modelUser?.id
//                       ? CrossAxisAlignment.end
//                       : CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       chatConsultationFormModel.user!.fullName == ''
//                           ? 'کاربر مهمان'
//                           : chatConsultationFormModel.user!.fullName ??
//                               'کاربر مهمان',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     Image.asset(
//                       'assets/images/form_image_3.jpg',
//                       fit: BoxFit.fill,
//                       height: 100,
//                       width: 100,
//                     ),
//                     const Text('Consultation form'),
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     Text(
//                       intl.DateFormat('HH:mm')
//                           .format(chatConsultationFormModel.date!)
//                           .toString(),
//                       style: const TextStyle(fontSize: 12),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             // color: model.user!.id == chatProvider.myUserId
//             //     ? Colors.grey[50]
//             //     : Colors.grey[300],
//           ),
//         ),
//         if (chatConsultationFormModel.user!.id == loginProvider.modelUser?.id)
//           Hero(
//             tag: chatConsultationFormModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 color: Colors.grey.shade400,
//                 shape: const CircleBorder(),
//                 child: chatConsultationFormModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatConsultationFormModel.user!,
//                                     tag: chatConsultationFormModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatConsultationFormModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget itemChatPatientInfo(
//       BuildContext context, ChatPatientInfoFormModel chatPatientInfoFormModel) {
//     final loginProvider = context.read<LoginProvider>();
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (chatPatientInfoFormModel.user!.id != loginProvider.modelUser?.id)
//           Hero(
//             tag: chatPatientInfoFormModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: const CircleBorder(),
//                 child: chatPatientInfoFormModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatPatientInfoFormModel.user!,
//                                     tag: chatPatientInfoFormModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatPatientInfoFormModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//         Flexible(
//           child: Card(
//             margin: const EdgeInsets.all(6),
//             child: InkWell(
//               onTap: () => {},
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: chatPatientInfoFormModel.user!.id ==
//                           loginProvider.modelUser?.id
//                       ? CrossAxisAlignment.end
//                       : CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       chatPatientInfoFormModel.user!.fullName == ''
//                           ? 'کاربر مهمان'
//                           : chatPatientInfoFormModel.user!.fullName ??
//                               'کاربر مهمان',
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     Image.asset(
//                       'assets/images/form_image_4.jpg',
//                       fit: BoxFit.fill,
//                       height: 100,
//                       width: 100,
//                     ),
//                     const Text('Patient Info form'),
//                     const SizedBox(
//                       height: 4,
//                     ),
//                     Text(
//                       intl.DateFormat('HH:mm')
//                           .format(chatPatientInfoFormModel.date!)
//                           .toString(),
//                       style: const TextStyle(fontSize: 12),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         if (chatPatientInfoFormModel.user!.id == loginProvider.modelUser?.id)
//           Hero(
//             tag: chatPatientInfoFormModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: const CircleBorder(),
//                 child: chatPatientInfoFormModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatPatientInfoFormModel.user!,
//                                     tag: chatPatientInfoFormModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatPatientInfoFormModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget itemChatVoice(BuildContext context, ChatVoiceModel chatVoiceModel) {
//     final loginProvider = context.read<LoginProvider>();
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (chatVoiceModel.user!.id != loginProvider.modelUser?.id)
//           Hero(
//             tag: chatVoiceModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 color: Colors.grey.shade400,
//                 shape: const CircleBorder(),
//                 child: chatVoiceModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatVoiceModel.user!,
//                                     tag: chatVoiceModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatVoiceModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//         Flexible(
//           child: Card(
//             margin: const EdgeInsets.all(6),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Column(
//                 crossAxisAlignment:
//                     chatVoiceModel.user!.id == loginProvider.modelUser?.id
//                         ? CrossAxisAlignment.end
//                         : CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     chatVoiceModel.user!.fullName == ''
//                         ? 'کاربر مهمان'
//                         : chatVoiceModel.user!.fullName ?? 'کاربر مهمان',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                     maxLines: 1,
//                   ),
//                   const SizedBox(
//                     height: 4,
//                   ),
//                   SizedBox(
//                     width: 270,
//                     child: Row(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.grey.shade50,
//                           ),
//                           child: FutureBuilder<Directory>(
//                               future: getTemporaryDirectory(),
//                               builder: (context, snapshot) {
//                                 if (snapshot.hasData) {
//                                   String fullPath =
//                                       "${snapshot.data!.path}/${chatVoiceModel.fileUrl}";
//                                   bool exist = File(fullPath).existsSync();
//                                   return Consumer<ChatProvider>(
//                                       builder: (context, chatProvider, child) {
//                                     if (chatVoiceModel.downloadProgress !=
//                                             null &&
//                                         chatVoiceModel.downloadProgress! < 99) {
//                                       return CircularProgressIndicator(
//                                         value:
//                                             chatVoiceModel.downloadProgress! /
//                                                 100,
//                                       );
//                                     }
//                                     return IconButton(
//                                       onPressed: () async {
//                                         if (exist == false) {
//                                           chatProvider.downloadImage(
//                                               '/${chatVoiceModel.fileUrl}',
//                                               fullPath,
//                                               chatVoiceModel);
//                                         } else {
//                                           chatVoiceModel.isPlaying = true;
//                                           chatProvider.notifyListeners();
//                                           await chatVoiceModel.audioPlayer
//                                               .setFilePath(fullPath);
//                                           await chatVoiceModel.audioPlayer
//                                               .play();
//                                           await chatVoiceModel.audioPlayer
//                                               .pause();
//                                           chatVoiceModel.isPlaying = false;
//                                           chatProvider.notifyListeners();
//                                         }
//                                       },
//                                       icon: exist
//                                           ? chatVoiceModel.isPlaying
//                                               ? const Icon(Icons.pause)
//                                               : const Icon(Icons.play_arrow)
//                                           : const Icon(Icons.download),
//                                     );
//                                   });
//                                 }
//                                 return const CircularProgressIndicator();
//                               }),
//                         ),
//                         Expanded(
//                             child: Text(
//                           chatVoiceModel.fileUrl ?? '',
//                           maxLines: 1,
//                         ))
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     intl.DateFormat('HH:mm')
//                         .format(chatVoiceModel.date!)
//                         .toString(),
//                     style: const TextStyle(fontSize: 12),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//         if (chatVoiceModel.user!.id == loginProvider.modelUser?.id)
//           Hero(
//             tag: chatVoiceModel.id!,
//             child: SizedBox(
//               width: 45,
//               height: 45,
//               child: Card(
//                 margin: const EdgeInsets.all(5),
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 shape: const CircleBorder(),
//                 child: chatVoiceModel.user!.imgUrl != null
//                     ? InkWell(
//                         onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => DisplayProfilePage(
//                                     user: chatVoiceModel.user!,
//                                     tag: chatVoiceModel.id!,
//                                 ))),
//                         child: CachedNetworkImage(
//                             fit: BoxFit.cover,
//                             errorWidget: (context, error, stackTrace) {
//                               return const Center();
//                             },
//                             imageUrl:
//                                 '${RequestManager.baseUrl}/${chatVoiceModel.user!.imgUrl}'),
//                       )
//                     : Image.asset('assets/images/user.png'),
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget dialogSelectFile(BuildContext context) {
//     ChatProvider chatProvider = context.read<ChatProvider>();

//     return Dialog(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             onTap: () async {
//               await chatProvider.pickCameraImage(
//                   context, widget.modelPatient, true);
//               Navigator.pop(context);
//             },
//             trailing: const Icon(Icons.camera),
//             title: const Text('Camera'),
//           ),
//           ListTile(
//             onTap: () async {
//               await chatProvider.pickCameraImage(
//                   context, widget.modelPatient, false);
//               Navigator.pop(context);
//             },
//             trailing: const Icon(Icons.browse_gallery_outlined),
//             title: const Text('Gallery'),
//           ),
//           ListTile(
//             onTap: () async {
//               await chatProvider.pickFile(context, widget.modelPatient);
//               Navigator.pop(context);
//             },
//             trailing: const Icon(Icons.attach_file_outlined),
//             title: const Text('Document'),
//           ),
//         ],
//       ),
//     );
//   }
// }
