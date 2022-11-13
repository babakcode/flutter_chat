import 'package:chat_babakcode/constants/config.dart';
import 'package:chat_babakcode/models/room.dart';
import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/providers/home_provider.dart';
import 'package:chat_babakcode/providers/login_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_page.dart';
import 'package:chat_babakcode/ui/pages/home/home_setting.dart';
import 'package:chat_babakcode/ui/pages/qr_code/qr_scanner.dart';
import 'package:chat_babakcode/ui/pages/search/search_user_page.dart';
import 'package:chat_babakcode/ui/widgets/app_button_transparent.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../../../constants/app_constants.dart';
import '../../../providers/global_setting_provider.dart';
import '../../widgets/app_text_field.dart';
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
            //
            // SliverAppBar(
            //   title: Text('Stories'),
            //   collapsedHeight: 100,
            //   expandedHeight: 100,
            //   bottom: PreferredSize(child: Container(
            //     color: Colors.red,
            //     child: Center(child: Text("hi"),),
            //   ), preferredSize: Size.fromHeight(100)),
            // ),

            SliverAppBar(
              pinned: true,
              title: const Text('Chats'),
              leading: _width < 960
                  ? IconButton(
                      tooltip: 'open the drawer',
                      onPressed: () =>
                          _roomScaffoldKey.currentState?.openDrawer(),
                      icon: const Icon(Icons.more_vert_rounded))
                  : null,
              actions: [
                IconButton(
                  onPressed: () => showSearchUsersByToken(context),
                  icon: const Icon(Icons.search_rounded),
                ),
              ],
            ),
            // const SliverAppBar(
            //   backgroundColor: Colors.amber,
            //   title: Text('Kindacode.com'),
            //   expandedHeight: 30,
            //   collapsedHeight: 150,
            // ),
            // const SliverAppBar(
            //   backgroundColor: Colors.green,
            //   title: Text('Have a nice day'),
            //   floating: true,
            //   pinned: true,
            // ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 112),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    Room room = chatProvider.rooms[index];
                    Room.populateRoomFields(room, chatProvider.auth!.myUser!);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        leading: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
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
                        ),
                        title: Row(
                          children: [
                            Text(
                              room.roomName ?? 'guest',
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              (room.lastChat?.user?.name ?? '') + ' : ',
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: const TextStyle(fontSize: 10),
                              maxLines: 1,
                            ),
                            Expanded(
                                child: Text(
                              room.lastChat?.text ?? '',
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: const TextStyle(fontSize: 12),
                              maxLines: 1,
                            )),
                            Text(
                              ' ${intl.DateFormat('HH:mm').format(room.changeAt ?? DateTime.now())} ',
                              style: const TextStyle(fontSize: 10),
                            )
                          ],
                        ),
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
                        onTap: () {
                          if (kDebugMode) {
                            print(_width);
                          }
                          chatProvider.changeSelectedRoom(room);
                          if (_width < 600) {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const ChatPage()));
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                  childCount: chatProvider.rooms.length,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Consumer<HomeProvider>(
        builder: (_, provider, child) {
          return FloatingActionButton.extended(
            onPressed: () => floatingOnPressedEvent(context),
            label: const Text('New Message'),
            tooltip: "Find friends to talk",
            icon: const Icon(Icons.edit_rounded),
            isExtended: provider.extendedFloatingActionButton,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConfig.radiusCircular,
              ),
            ),
          );
        },
      ),
    );
  }

  showSearchUsersByToken(BuildContext context) {
    final globalSettingProvider = context.read<GlobalSettingProvider>();

    final chatProvider = context.read<ChatProvider>();
    final homeProvider = context.read<HomeProvider>();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConfig.radiusCircular)),
        backgroundColor: globalSettingProvider.isDarkTheme
            ? AppConstants.textColor[600]
            : AppConstants.textColor[50],
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: homeProvider.conversationTokenTextController,
                    ),
                  ),
                  if (LoginProvider.platform == 'android' ||
                      LoginProvider.platform == 'ios')
                    IconButton(
                        onPressed: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const QrScannerPage(),
                            ),
                          );

                          if (kDebugMode) {
                            print(result);
                          }
                          if (result != null) {
                            homeProvider.conversationTokenTextController.text =
                                result;
                          }
                        },
                        icon: const Icon(Icons.document_scanner_rounded))
                ],
              ),
              AppButtonTransparent(
                child: const Text('Find user'),
                onPressed: () {
                  chatProvider.addConversationPvUser(
                      token: homeProvider.conversationTokenTextController.text);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  floatingOnPressedEvent(BuildContext context) {
    final globalSettingProvider = context.read<GlobalSettingProvider>();
    showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      constraints: const BoxConstraints(maxWidth: 360),
      backgroundColor: globalSettingProvider.isDarkTheme
          ? AppConstants.textColor[800]
          : AppConstants.textColor[100],
      context: context,
      builder: (_) => DraggableScrollableSheet(
        maxChildSize: 0.7,
        expand: false,
        builder: (context, scrollController) => ListView(
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
              crossAxisCount: 3,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                itemGridViewModalBottomSheet(
                  globalSettingProvider,
                  onPressed: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrScannerPage(),
                      ),
                    );
                    if (result != null) {}
                  },
                  icon: Icons.qr_code_scanner_rounded,
                  text: 'Scan QR',
                ),
                itemGridViewModalBottomSheet(
                  globalSettingProvider,
                  onPressed: () async {
                    await Navigator.push(context, CupertinoPageRoute(builder: (context) => const SearchUserPage()),);
                  },
                  icon: Icons.person_search,
                  text: 'search',
                ),
                itemGridViewModalBottomSheet(
                  globalSettingProvider,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(user: context.read<Auth>().myUser!)));
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
}
