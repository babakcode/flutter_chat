import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_bottom_nav.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_text_item.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../models/chat_appbar_model.dart';
import '../../../models/room.dart';
import '../../../models/user.dart';
import '../../../providers/auth_provider.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    ChatProvider chatProvider = context.watch<ChatProvider>();
    Room? room = chatProvider.selectedRoom;
    ChatAppBarModel chatAppBarModel = ChatAppBarModel();
    if (_width >= 600 && Navigator.canPop(context)) {
      Future.microtask(() => Navigator.pop(context));
    }
    final auth = context.read<Auth>();
    switch (room?.roomType) {
      case RoomType.pvUser:
        User friend = room!.members!
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
    return (room == null)
        ? const Scaffold(
            body: Center(child: AppText('please select chat room')),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    if(Navigator.canPop(context)){
                      Navigator.pop(context);
                    }
                    if (_width <= 600) {
                    } else {
                      // disable selected
                      // Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.arrow_back_ios_rounded)),
              title: Text(chatAppBarModel.roomName ?? 'guest'),
              actions: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.more_vert_rounded))
              ],
            ),
            body: Column(
              children: [
                Expanded(
                    child: NotificationListener<ScrollNotification>(
                  child: ScrollablePositionedList.builder(
                      reverse: true, itemCount: 20, itemBuilder: chatItem),
                )),
                ChatBottomNavComponent(
                  room: room,
                )
              ],
            ),
          );
  }

  Widget chatItem(BuildContext context, int index) {
    double _width = MediaQuery.of(context).size.width;

    int _testIndexForDetectAccount = 5;

    bool fromMyAccount = (index % _testIndexForDetectAccount) == 0;
    bool previusChatFromUser = false;
    bool nextChatFromUser = false;
    bool middleChatFromUser = false;

    try {
      previusChatFromUser =
          ((index - 1) % _testIndexForDetectAccount == 0) == fromMyAccount;
      nextChatFromUser =
          ((index + 1) % _testIndexForDetectAccount == 0) == fromMyAccount;
      middleChatFromUser = (previusChatFromUser && nextChatFromUser);
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
              ? 4
              : previusChatFromUser
                  ? 4
                  : 8,
          top: middleChatFromUser
              ? 4
              : nextChatFromUser
                  ? 4
                  : 8),
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
                child: previusChatFromUser
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
            child: ChatTextItem(index, fromMyAccount, previusChatFromUser,
                nextChatFromUser, middleChatFromUser),
          ),
        ],
      ),
    );
  }
}
