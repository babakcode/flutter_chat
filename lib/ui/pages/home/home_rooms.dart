import 'package:chat_babakcode/models/chat.dart';
import 'package:chat_babakcode/models/room.dart';
import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/providers/home_provider.dart';
import 'package:chat_babakcode/providers/login_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_page.dart';
import 'package:chat_babakcode/ui/pages/home/home_setting.dart';
import 'package:chat_babakcode/ui/pages/qr_code/qr_scanner.dart';
import 'package:chat_babakcode/ui/pages/search/search_user_page.dart';
import 'package:chat_babakcode/ui/pages/security/security_page.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:chat_babakcode/ui/widgets/app_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:phlox_animations/phlox_animations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/app_constants.dart';
import '../../../providers/global_setting_provider.dart';
import '../../../utils/notification_controller.dart';
import '../../../utils/utils.dart';
import '../qr_code/qr_page.dart';

class HomeRoomsComponent extends StatefulWidget {
  const HomeRoomsComponent({super.key});

  @override
  State<HomeRoomsComponent> createState() => _HomeRoomsComponentState();
}

class _HomeRoomsComponentState extends State<HomeRoomsComponent> {
  final GlobalKey<ScaffoldState> _roomScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final globalSettingProvider = context.watch<GlobalSettingProvider>();

    final chatProvider = context.watch<ChatProvider>();

    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _roomScaffoldKey,
      drawer: _width < 960 ? const Drawer(child: HomeSettingComponent()) : null,
      backgroundColor: globalSettingProvider.isDarkTheme
          ? AppConstants.textColor[800]
          : AppConstants.textColor[100],
      body: NotificationListener<UserScrollNotification>(
        onNotification:
            context.read<HomeProvider>().toggleExtendedFloatingActionButton,
        child: CustomScrollView(
          controller: ScrollController(),
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,

              title: !chatProvider.showSearchRoomsBox?Text(chatProvider.connectionStatus ?? 'Chats') : TextField(
                onChanged: (value) {
                  chatProvider.findRooms(value);
                },
                decoration: const InputDecoration(
                  hintText: 'Room name'
                ),
              ),
              leading: _width < 960
                  ? IconButton(
                      tooltip: 'open navigation menu',
                      onPressed: () =>
                          _roomScaffoldKey.currentState?.openDrawer(),
                      icon: const Icon(Icons.menu_rounded))
                  : null,
              actions: [
                IconButton(
                  onPressed: () => {
                    /*showSearchUsersByToken(context)*/
                    //NotificationController.createNewNotification()

                    chatProvider.checkSearchMode()
                  },
                  icon: const Icon(Icons.search_rounded),
                ),
              ],
            ),
            if(chatProvider.updateAvailable || globalSettingProvider.showSecurityRecoveryPhrase )
              SliverList(
              delegate: SliverChildListDelegate.fixed([
                if (globalSettingProvider.showSecurityRecoveryPhrase)
                  ListTile(
                    tileColor: globalSettingProvider.isDarkTheme
                        ? AppConstants.textColor[800]
                        : const Color(0xFFCFE9F8),
                    title: const Text('Get recovery phrase'),
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const SecurityPage())),
                    trailing: Stack(
                      children:  [
                        const Icon(Icons.security_rounded),
                        PhloxAnimations(
                          loop: true,
                          duration: const Duration(seconds: 1),
                          fromOpacity: .01,
                          toOpacity: 1,
                          child: Icon(
                            Icons.circle,
                            size: 12,
                            color: AppConstants.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (chatProvider.updateAvailable)
                  ListTile(
                    tileColor: AppConstants.blueAccent,
                    onTap: () async {
                      if (!await launchUrl(AppConstants.appLandingWebPageUri)) {
                        throw 'Could not launch ${AppConstants.appLandingWebPageUri}';
                      }
                    },
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    title: const Text('Update available'),
                    trailing: const Icon(Icons.system_update_rounded),
                  ),
              ]),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 112),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Room room = chatProvider.roomsFromSearch != null ? chatProvider.roomsFromSearch![index] : chatProvider.rooms[index];
                    Room.populateRoomFields(room, chatProvider.auth!.myUser!);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: ListTile(
                        title: _roomItemTitle(room, globalSettingProvider),
                        subtitle: _roomItemSubTitle(room),
                        leading: _roomItemLeading(room),
                        onTap: () {
                          chatProvider.changeSelectedRoom(room);
                          if (_width < 600) {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const ChatPage()));
                          }
                        },
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        selectedTileColor: globalSettingProvider.isDarkTheme
                            ? AppConstants.textColor[300]
                            : AppConstants.scaffoldLightBackground,
                        tileColor: GlobalSettingProvider.isPhonePortraitSize
                            ? globalSettingProvider.isDarkTheme
                                ? AppConstants.textColor[700]
                                : AppConstants.scaffoldLightBackground
                            : null,
                        selected: GlobalSettingProvider.isPhonePortraitSize
                            ? false
                            : chatProvider.selectedRoom == room,
                        minLeadingWidth: 30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                  childCount: chatProvider.roomsFromSearch != null ? chatProvider.roomsFromSearch!.length :chatProvider.rooms.length,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Consumer<HomeProvider>(
        builder: (_, provider, child) {
          return AnimatedSize(
            duration: const Duration(milliseconds: 100),
            child: FloatingActionButton.extended(
              onPressed: () => floatingOnPressedEvent(context),
              label: const Text('New Message'),
              tooltip: "Find friends to talk",
              icon: const Icon(Icons.edit_rounded),
              isExtended: provider.extendedFloatingActionButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.radiusCircular,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // showSearchUsersByToken(BuildContext context) {
  //   final globalSettingProvider = context.read<GlobalSettingProvider>();
  //
  //   final chatProvider = context.read<ChatProvider>();
  //   final homeProvider = context.read<HomeProvider>();
  //   showDialog(
  //     context: context,
  //     builder: (context) => Dialog(
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(AppConstants.radiusCircular)),
  //       backgroundColor: globalSettingProvider.isDarkTheme
  //           ? AppConstants.textColor[600]
  //           : AppConstants.textColor[50],
  //       child: ConstrainedBox(
  //         constraints: const BoxConstraints(maxWidth: 500),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: AppTextField(
  //                     controller: homeProvider.conversationTokenTextController,
  //                   ),
  //                 ),
  //                 if (LoginProvider.platform == 'android' ||
  //                     LoginProvider.platform == 'ios')
  //                   IconButton(
  //                       onPressed: () async {
  //                         var result = await Navigator.push(
  //                           context,
  //                           CupertinoPageRoute(
  //                             builder: (context) => const QrScannerPage(),
  //                           ),
  //                         );
  //
  //                         if (kDebugMode) {
  //                           print(result);
  //                         }
  //                         if (result != null) {
  //                           homeProvider.conversationTokenTextController.text =
  //                               result;
  //                         }
  //                       },
  //                       icon: const Icon(Icons.document_scanner_rounded))
  //               ],
  //             ),
  //             AppButtonTransparent(
  //               child: const Text('Find user'),
  //               onPressed: () {
  //                 chatProvider.searchRoomWith(
  //                     token: homeProvider.conversationTokenTextController.text,
  //                   context: context
  //                 );
  //               },
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  floatingOnPressedEvent(BuildContext context) {
    final globalSettingProvider = context.read<GlobalSettingProvider>();
    final _width = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      constraints: BoxConstraints(
          maxWidth: _width <= 500
              ? 360
              : _width > 760
                  ? 742
                  : _width),
      backgroundColor: globalSettingProvider.isDarkTheme
          ? AppConstants.textColor[800]
          : AppConstants.textColor[100],
      context: context,
      builder: (_) => DraggableScrollableSheet(
        maxChildSize: 0.7,
        expand: false,
        builder: (_, scrollController) => ListView(
          controller: scrollController,
          children: [
            const Divider(
              color: Colors.blueGrey,
              indent: 100,
              endIndent: 100,
              height: 23,
              thickness: 3,
            ),
            const Center(
              child: AppText(
                'Add conversation',
                size: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  'Give your QR code to a friend who wanna text you or create new conversation',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GridView.count(
              crossAxisCount: _width ~/ 130,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                if (LoginProvider.platform == 'android' ||
                    LoginProvider.platform == 'ios')
                  itemGridViewModalBottomSheet(
                    globalSettingProvider,
                    onPressed: () async {
                      var result = await Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const QrScannerPage(),
                        ),
                      );
                      if (result != null) {
                        final chatProvider = context.read<ChatProvider>();
                        chatProvider.searchUser(
                            searchType: 'token',
                            searchText: result,
                            context: context,
                            callBack: (data) {
                              if (data['success']) {
                                // loading = false;
                                // notifyListeners();

                                Room room = data['room'];

                                chatProvider.selectedRoom = room;
                                Future.microtask(() =>
                                    chatProvider.notifyListeners());
                                // if(chatProvider.rooms.where((element) => element.id == chatProvider.selectedRoom!.id).isEmpty){
                                //   chatProvider.rooms.add(room);
                                //   int index = chatProvider.rooms.indexWhere((element) => element.id == room.id);
                                //   chatProvider.selectedRoom = chatProvider.rooms[index];
                                // }

                                Navigator.pop(context);

                                if (GlobalSettingProvider.isPhonePortraitSize) {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => const ChatPage(),
                                      ));
                                } else {
                                  chatProvider.notifyListeners();
                                }
                                // if(data['findFromExistRoom']){
                                //
                                //   /// room found
                                //
                                //   if (GlobalSettingProvider.isPhonePortraitSize) {
                                //     Navigator.push(
                                //         context,
                                //         CupertinoPageRoute(
                                //           builder: (context) => const ChatPage(),
                                //         ));
                                //   } else {
                                //     notifyListeners();
                                //   }
                                // }else{
                                //
                                //   selectedRoom = Room.fromJson(data['room'], false);
                                //
                                //   if (GlobalSettingProvider.isPhonePortraitSize) {
                                //     Navigator.push(
                                //       navigatorKey.currentContext!,
                                //       CupertinoPageRoute(
                                //         builder: (context) => const ChatPage(),
                                //       ),
                                //     );
                                //   } else {
                                //     notifyListeners();
                                //   }
                                // }

                              } else {
                                Utils.showSnack(context, data['msg']);
                              }
                            });
                      }
                    },
                    icon: Icons.qr_code_scanner_rounded,
                    text: 'Scan QR',
                  ),
                itemGridViewModalBottomSheet(
                  globalSettingProvider,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const SearchUserPage()),
                    );
                  },
                  icon: Icons.person_search,
                  text: 'search',
                ),
                itemGridViewModalBottomSheet(
                  globalSettingProvider,
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                QrPage(user: context.read<Auth>().myUser!)));
                  },
                  icon: Icons.qr_code_2_rounded,
                  text: 'My QR',
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Wrap(
              children: [
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      leading: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: const SizedBox(
                            height: 36,
                            width: 36,
                            child: Icon(Icons.add_alert_rounded)),
                      ),
                      title: const AppText("create channel"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minLeadingWidth: 30,
                      onTap: () {},
                      trailing:
                          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      tileColor: globalSettingProvider.isDarkTheme
                          ? AppConstants.textColor[900]
                          : AppConstants.scaffoldLightBackground,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget itemGridViewModalBottomSheet(
      GlobalSettingProvider globalSettingProvider,
      {required VoidCallback onPressed,
      required IconData icon,
      required String text}) {
    return Card(
      elevation: 0,
      color: globalSettingProvider.isDarkTheme
          ? AppConstants.textColor[700]
          : AppConstants.scaffoldLightBackground,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Icon(
                  icon,
                  color: globalSettingProvider.isDarkTheme
                      ? AppConstants.textColor[50]
                      : AppConstants.primarySwatch[900],
                  size: 42,
                )),
            Expanded(
                flex: 1,
                child: AppText(
                  text,
                  color: globalSettingProvider.isDarkTheme
                      ? AppConstants.textColor[100]
                      : AppConstants.primarySwatch[700],
                ))
          ],
        ),
      ),
    );
  }

  Widget _roomItemTitle(Room room, GlobalSettingProvider settingProvider) {
    return Row(
      children: [
        Flexible(
          child: Text(
            room.roomName ?? 'guest',
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ),

        if (room.verified)
          SvgPicture.asset(
            'assets/svg/verified_account.svg',
            height: 25,
            width: 25,
          ),

        /// show not read chats count
        if ((room.lastChat?.chatNumberId ?? -1) - (room.lastIndex ?? -1) > 0)
          Card(
            color: AppConstants.blueAccent,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
              child: Text(
                '${(room.lastChat?.chatNumberId ?? 0) - (room.lastIndex ?? 0)}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: settingProvider.isDarkTheme
                        ? AppConstants.scaffoldDarkBackground
                        : AppConstants.scaffoldLightBackground),
              ),
            ),
          ),
      ],
    );
  }

  Widget _roomItemSubTitle(Room room) => Row(
        children: [
          if (room.lastChat != null)
            Text(
              (room.lastChat!.user?.name ?? '') + ' : ',
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: const TextStyle(fontSize: 10),
              maxLines: 1,
            ),
          Expanded(child: Builder(builder: (context) {
            String displayLastChat = '';
            if (room.lastChat is ChatTextModel) {
              ChatTextModel? chat = room.lastChat as ChatTextModel;
              displayLastChat = chat.text ?? '';
            } else if (room.lastChat is ChatPhotoModel) {
              displayLastChat = 'Photo';
            } else if (room.lastChat is ChatDocModel) {
              displayLastChat = 'Document';
            } else if (room.lastChat is ChatVoiceModel) {
              displayLastChat = 'Voice';
            } else if (room.lastChat is ChatUpdateRequireModel) {
              displayLastChat =
                  'this message is not supported on your version of business chat!';
            }
            return Text(
              displayLastChat,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
            );
          })),
          Text(
            ' ${intl.DateFormat('HH:mm').format(room.changeAt ?? DateTime.now())} ',
            style: const TextStyle(fontSize: 10),
          )
        ],
      );

  Widget _roomItemLeading(Room room) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: SizedBox(
          height: 36,
          width: 36,
          child: room.roomImage == null
              ? Room.generateProfileImageByName(room)
              : Image.network(
                  room.roomImage!,
                  fit: BoxFit.cover,
                ),
        ),
      );
}
