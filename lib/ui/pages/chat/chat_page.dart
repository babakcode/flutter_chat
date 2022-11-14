import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/providers/login_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_bottom_nav.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_text_item.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../models/chat.dart';
import '../../../models/chat_appbar_model.dart';
import '../../../models/room.dart';
import '../../../models/user.dart';
import '../../../providers/auth_provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _canPop = true;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final chatProvider = context.watch<ChatProvider>();

    final _bottomNavigationBarHeight =
        (LoginProvider.platform == 'android' || LoginProvider.platform == 'ios')
            ? MediaQuery.of(context).viewPadding.vertical
            : 0;
    final auth = context.read<Auth>();

    ChatAppBarModel chatAppBarModel = ChatAppBarModel();

    if (_width >= 595 && Navigator.canPop(context) && _canPop) {
      Future.microtask(() {
        if (Navigator.canPop(context) && _canPop) {
          Navigator.pop(context);
          chatProvider.deselectRoom();
          _canPop = false;
        }
      });
      return const SizedBox();
    }

    if (chatProvider.selectedRoom != null) {
      if (kDebugMode) {
        print('-----------roomId is---------');
        print(chatProvider.selectedRoom!.id);
        print('-----------------------------');
      }
      switch (chatProvider.selectedRoom!.roomType) {
        case RoomType.pvUser:
          if (chatProvider.selectedRoom!.members![0].user!.id ==
                  auth.myUser!.id &&
              chatProvider.selectedRoom!.members![1].user!.id ==
                  auth.myUser!.id) {
            chatAppBarModel
              ..roomName = 'my Messages'
              ..roomImage = auth.myUser!.profileUrl
              ..roomType = RoomType.pvUser;
            break;
          }

          User friend = chatProvider.selectedRoom!.members!
              .firstWhere((element) => element.user!.id != auth.myUser!.id)
              .user!;
          chatAppBarModel
            ..roomName = friend.name
            ..roomImage = friend.profileUrl
            ..roomType = RoomType.pvUser;
          break;
        case RoomType.publicGroup:
          // TODO: Handle this case.
          break;
        case RoomType.pvGroup:
          // TODO: Handle this case.
          break;
        case RoomType.channel:
          // TODO: Handle this case.
          break;
        default:
          {}
      }
    }

    if ((chatProvider.selectedRoom == null)) {
      return const Scaffold(
        body: Center(child: AppText('please select chat room')),
      );
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    chatProvider.deselectRoom();
                  }
                },
                icon: const Icon(Icons.arrow_back_ios_rounded)),
            title: Text(chatAppBarModel.roomName ?? 'guest'),
            actions: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
            ],
          ),
          body: SingleChildScrollView(
            reverse: true,
            controller: ScrollController(),
            physics: const NeverScrollableScrollPhysics(),
            // physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  height: MediaQuery.of(context).size.height -
                      64 -
                      AppBar().preferredSize.height -
                      _bottomNavigationBarHeight,
                  child: ScrollablePositionedList.builder(
                    // physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 100),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemScrollController: chatProvider.itemScrollController,
                    addAutomaticKeepAlives: true,
                    // initialScrollIndex: ,
                    itemPositionsListener: chatProvider.itemPositionsListener,
                    // initialScrollIndex: room.roomPositionIndex!.max,
                    // controller: chatProvider.chatListViewController,
                    itemCount: chatProvider.selectedRoom!.chatList.length,
                    itemBuilder: chatItem,
                  ),
                ),
                ChatBottomNavComponent(
                  room: chatProvider.selectedRoom!,
                )
              ],
            ),
          ));
    }
  }

  Widget chatItem(BuildContext context, int index) {
    double _width = MediaQuery.of(context).size.width;

    var chatProvider = context.read<ChatProvider>();

    Room room = chatProvider.selectedRoom!;

    Chat? chat = room.chatList[index];

    bool fromMyAccount = chat.user!.id == chatProvider.auth!.myUser!.id;
    bool previousChatFromUser = false;
    bool nextChatFromUser = false;
    bool middleChatFromUser = false;

    try {
      previousChatFromUser = (room.chatList[index - 1].user!.id ==
              chatProvider.auth!.myUser!.id) ==
          fromMyAccount;
      nextChatFromUser = (room.chatList[index + 1].user!.id ==
              chatProvider.auth!.myUser!.id) ==
          fromMyAccount;
      middleChatFromUser = (previousChatFromUser && nextChatFromUser);
      // ignore: empty_catches
    } catch (e) {}
    // if (kDebugMode) {
    //   print('--- ( $index ) -------------------------');
    //   print('fromMyAccount = $fromMyAccount');
    //   print('previusChatFromUser = $previusChatFromUser');
    //   print('nextChatFromUser = $nextChatFromUser');
    //   print('middleChatFromUser = $middleChatFromUser');
    // }

    return Container(
      padding: EdgeInsets.only(
          right: 8,
          left: 8,
          bottom: middleChatFromUser
              ? 2
              : nextChatFromUser
                  ? 2
                  : previousChatFromUser
                      ? 2
                      : 16,
          top: middleChatFromUser
              ? 2
              : previousChatFromUser
                  ? 2
                  : nextChatFromUser
                      ? 2
                      : 16),
      alignment: fromMyAccount ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!fromMyAccount)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                height: 36,
                width: 36,
                child: nextChatFromUser
                    ? null
                    : Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.asset(
                          'assets/images/p2.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: _width *
                  (GlobalSettingProvider.isPhonePortraitSize ? .8 : .3),
            ),

            ///
            child: ChatTextItem(index, fromMyAccount, previousChatFromUser,
                nextChatFromUser, middleChatFromUser),
          ),
        ],
      ),
    );
  }
}
