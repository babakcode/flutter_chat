import 'package:chat_babakcode/constants/config.dart';
import 'package:chat_babakcode/models/room.dart';
import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/providers/home_provider.dart';
import 'package:chat_babakcode/providers/login_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_page.dart';
import 'package:chat_babakcode/ui/pages/home/home_setting.dart';
import 'package:chat_babakcode/ui/pages/qr_code/qr_scanner.dart';
import 'package:chat_babakcode/ui/widgets/app_button_transparent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../../../constants/app_constants.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/global_setting_provider.dart';
import '../../widgets/app_text_field.dart';

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
    final homeProvider = context.read<HomeProvider>();

    final _width = MediaQuery.of(context).size.width;

    print(LoginProvider.platform);

    return Scaffold(
        key: _roomScaffoldKey,
        drawer:
            _width < 960 ? const Drawer(child: HomeSettingComponent()) : null,
        backgroundColor: globalSettingProvider.isDarkTheme
            ? AppConstants.textColor[800]
            : AppConstants.textColor[100],
        body: SafeArea(
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
                    onPressed: () => showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppConfig.radiusCircular)),
                              backgroundColor: globalSettingProvider.isDarkTheme
                                  ? AppConstants.textColor[600]
                                  : AppConstants.textColor[50],
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppTextField(
                                            controller: homeProvider
                                                .conversationTokenTextController,
                                          ),
                                        ),
                                        if (LoginProvider.platform ==
                                                'android' ||
                                            LoginProvider.platform == 'ios')
                                          IconButton(
                                              onPressed: () async {
                                                var result =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const QrScannerPage(),
                                                        ));

                                                print(result);
                                                if(result != null){
                                                  homeProvider
                                                      .conversationTokenTextController
                                                      .text = result;
                                                }
                                              },
                                              icon: const Icon(Icons
                                                  .document_scanner_rounded))
                                      ],
                                    ),
                                    AppButtonTransparent(
                                      child: const Text('Find user'),
                                      onPressed: () {
                                        chatProvider.addConversationPvUser(
                                            token: homeProvider
                                                .conversationTokenTextController
                                                .text);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            )),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // todo : change item widgets value
                      Room room = chatProvider.rooms[index];
                      Room.populateRoomFields(
                          room, chatProvider.auth!.myUser!);

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
                            print(_width);
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
        ));
  }
}
