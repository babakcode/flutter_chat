// import 'dart:convert';
// import 'dart:math';
// import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
// import 'package:detectable_text_field/functions.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:provider/provider.dart';
// import '/constants/app_constants.dart';
// import '/controllers/reguest/home_requests.dart';
// import '/models/chat_model.dart';
// import '/models/model_patient.dart';
// import '/providers/login_provider.dart';
// import '/providers/profile_provider.dart';
// import '/ui/pages/chat/chat_page.dart';
// import '/ui/pages/profile/profile_user_page.dart';
// import '/ui/pages/search/search_page.dart';
// import '../../../providers/chat_provider.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   Future<void> setupInteractedMessage() async {
//     // Get any messages which caused the application to open from
//     // a terminated state.
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true,
//       sound: true,
//     );

//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }
//     // Also handle any interaction when the app is in the background via a
//     // Stream listener
//     FirebaseMessaging.onMessage.listen(_handleMessage);
//     // FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
//   }

//   void _handleMessage(RemoteMessage message) async {

//     try {

//       final chatProvider = context.read<ChatProvider>();
//       final loginProvider = context.read<LoginProvider>();
//       String notificationTitle = message.notification?.title ?? '';

//       var data = jsonDecode(message.data['message']);
//       var chat = ChatModel.detectChatModelType(data['chat']);

//       AndroidNotificationDetails androidPlatformChannelSpecifics =
//       const AndroidNotificationDetails(
//           'high_importance_channel', // id
//           'High Importance Notifications',
//           channelDescription:
//           'This channel is used for important notifications.',
//           importance: Importance.max,
//           priority: Priority.high,
//           ticker: 'ticker');
//       NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);

//       switch (data['type']) {
//         case 'chat':
//           if (chat.groupId == chatProvider.weAreInThisGroup ||
//                   chat.user!.id == loginProvider.modelUser?.id ||
//                   loginProvider.mutedAll // برای بی صدا کردن چت ها
//               ) {
//             return;
//           }
//           break;
//         case 'mention':
//           {
//             chat = chat as ChatTextModel;
//             if (chat.groupId == chatProvider.weAreInThisGroup ||
//                 chat.user!.id == loginProvider.modelUser?.id) {
//               return;
//             }
//             final List<String> detections =
//                 extractDetections(chat.text ?? '', hashTagAtSignUrlRegExp);
//             if (detections
//                 .where((element) =>
//                     element == '@${loginProvider.modelUser?.username}')
//                 .isNotEmpty) {
//               notificationTitle = "Tagged you in a message";
//             }
//             break;
//           }
//       }

//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;

//       // If `onMessage` is triggered with a notification, construct our own
//       // local notification to show to users using the created channel.

//       if (notification != null && android != null) {
//         FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//             FlutterLocalNotificationsPlugin();
//         await flutterLocalNotificationsPlugin.initialize(
//             const InitializationSettings(
//                 android: AndroidInitializationSettings('@mipmap/app_logo_foreground'),
//                 iOS: null,
//                 macOS: null));

// // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//         await flutterLocalNotificationsPlugin.show(
//             Random().nextInt(100),
//             notificationTitle,
//             message.notification?.body,
//             platformChannelSpecifics,
//             payload: message.data['message']);
//       }
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     //setupInteractedMessage();'
//     // if(!kIsWeb){
//     //   setupInteractedMessage();
//     //   FirebaseMessaging.instance.subscribeToTopic('allUsers').then((value) {});
//     // }
//     Future.microtask(() async {
//       final loginProvider = context.read<LoginProvider>();
//       context.read<ChatProvider>().socket
//         ..connect()
//         ..auth = {'token': loginProvider.modelUser?.token};

//       HomeRequests.home(context, date: context.read<ChatProvider>().lastDate)
//           .then((value) {
//         context.read<ChatProvider>().addPatient(value);
//       });

//     });
//     super.initState();
//   }


//   @override
//   Widget build(BuildContext context) {

//     final chatProvider = Provider.of<ChatProvider>(context, listen: false);
//     final loginProvider = context.read<LoginProvider>();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("collaborative team"),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(20),
//           child: Container(
//             color: AppConstants.primarySwatch,
//             padding: const EdgeInsets.all(12),
//             child: const Text("Chat"),
//           ),
//         ),
//         actions: [
//           Consumer<LoginProvider>(builder: (_, loginProvider, __) {
//             return IconButton(
//                 onPressed: () =>
//                     loginProvider.muteAll = !loginProvider.mutedAll,
//                 icon: Icon(loginProvider.mutedAll
//                     ? Icons.volume_off_rounded
//                     : Icons.volume_up_rounded));
//           }),
//           IconButton(
//               onPressed: () async {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const SearchPage(),
//                     ));
//               },
//               icon: const Icon(Icons.search)),
//           PopupMenuButton<int>(
//               // Callback that sets the selected popup menu item.
//               onSelected: (int? item) async {
//                 switch (item) {
//                   case 1:
//                     {
//                       break;
//                     }
//                   case 2:
//                     {
//                       if (context
//                           .read<ProfileProvider>()
//                           .getDataFromSharedToTextController(loginProvider)) {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const ProfilePage(),
//                             ));
//                       }
//                       break;
//                     }
//                   case 3:
//                     {
//                       if (context
//                           .read<ProfileProvider>()
//                           .getDataFromSharedToTextController(loginProvider)) {
//                         context
//                             .read<ProfileProvider>()
//                             .getDataFromSharedToTextController(loginProvider);
//                       }
//                       context
//                           .read<LoginProvider>()
//                           .clearTokenAndLogOut(context);
//                       break;
//                     }
//                 }
//               },
//               itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
//                     const PopupMenuItem(
//                       value: 1,
//                       child: Text('New patient'),
//                     ),
//                     const PopupMenuItem(
//                       value: 2,
//                       child: Text('Profile'),
//                     ),
//                     const PopupMenuItem(
//                       value: 3,
//                       child: Text('Log out'),
//                     ),
//                   ]),
//         ],
//       ),
//       body: NotificationListener<ScrollNotification>(
//         onNotification: (ScrollNotification scrollInfo) {
//           if (chatProvider.isLoadMoreGroup == false &&
//               chatProvider.isLastRequestGroup == false) {
//             if (scrollInfo.metrics.pixels ==
//                 scrollInfo.metrics.maxScrollExtent) {
//               debugPrint('loadMore');
//               chatProvider.changeLastDate = chatProvider.listPatient.last.date;
//               HomeRequests.home(context,
//                       date: context.read<ChatProvider>().lastDate)
//                   .then((listPatients) {
//                 if (listPatients.isEmpty) {
//                   chatProvider.isLastRequestGroup = true;
//                   return;
//                 }
//                 context.read<ChatProvider>().addPatient(listPatients);
//               });
//             }
//           }
//           return false;
//         },
//         child: Consumer<ChatProvider>(builder: (_, chatProvider, child) {
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 ListView.separated(
//                   separatorBuilder: (context, index) => const Divider(
//                     color: Colors.grey,
//                     height: 2,
//                   ),
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) =>
//                       groupItem(context, chatProvider.listPatient[index]),
//                   itemCount: chatProvider.listPatient.length,
//                 ),
//                 if (chatProvider.isLoadMoreGroup)
//                   const Padding(
//                     padding: EdgeInsets.only(bottom: 60.0),
//                     child: CircularProgressIndicator(),
//                   ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget groupItem(BuildContext context, ModelPatient modelPatient) {
//     return ListTile(
//       onTap: () {
//         context.read<ChatProvider>().setWeAreInThisGroup = modelPatient.id;
//         // context.read<ChatProvider>().patientChats = context
//         //     .read<ChatProvider>()
//         //     .chats
//         //     .where((element) => element.id == (index + 1))
//         //     .toList();
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ChatPage(modelPatient: modelPatient),
//             ));
//       },
//       title: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Flexible(
//                   child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 6),
//                       margin: const EdgeInsets.symmetric(horizontal: 6),
//                       color: Colors.grey.shade200,
//                       child: Text(modelPatient.patientCode))),
//               Flexible(child: Text(modelPatient.patientName)),
//             ],
//           ),
//           const SizedBox(
//             height: 8,
//           ),
//           Text(
//             modelPatient.lastChat,
//             maxLines: 1,
//             style: const TextStyle(fontSize: 14),
//           )
//         ],
//       ),
//     );
//   }
// }
