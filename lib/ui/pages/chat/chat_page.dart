import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/providers/login_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_bottom_nav.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/room.dart';
import '../../../models/user.dart';
import '../../../providers/auth_provider.dart';
import 'chat_scrollable_list.dart';


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _canPop = true;
  final _scrollViewController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final chatProvider = context.watch<ChatProvider>();
    final auth = context.read<Auth>();

    if (chatProvider.selectedRoom != null) {
      if (chatProvider.selectedRoom!.roomType == RoomType.pvUser) {
        if (chatProvider.selectedRoom!.members![0].user!.id ==
                auth.myUser!.id &&
            chatProvider.selectedRoom!.members![1].user!.id ==
                auth.myUser!.id) {
          chatProvider.selectedRoom!.roomName = 'my Messages';
          chatProvider.selectedRoom!.roomImage = auth.myUser!.profileUrl;
        } else {
          User friend = chatProvider.selectedRoom!.members!
              .firstWhere((element) => element.user!.id != auth.myUser!.id)
              .user!;
          chatProvider.selectedRoom!.roomName = friend.name;
          chatProvider.selectedRoom!.roomImage = friend.profileUrl;
        }
      }

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
    }

    final _bottomNavigationBarHeight =
        (LoginProvider.platform == 'android' || LoginProvider.platform == 'ios')
            ? MediaQuery.of(context).viewPadding.vertical
            : 0;

    return WillPopScope(
      onWillPop: () => chatProvider.onWillPopChatPage(context),
      child: Scaffold(
        appBar: chatProvider.selectedRoom == null
            ? null
            : AppBar(
                leading: IconButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        chatProvider.deselectRoom();
                      }
                    },
                    icon: const Icon(Icons.arrow_back_ios_rounded)),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chatProvider.selectedRoom!.roomName ?? 'guest'),
                    if (chatProvider.connectionStatus != null)
                      Text(
                        chatProvider.connectionStatus!,
                        style: const TextStyle(fontSize: 8),
                      )
                  ],
                ),
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert_rounded))
                ],
              ),
        body: chatProvider.selectedRoom == null
            ? const Center(child: AppText('please select chat room'))
            : SingleChildScrollView(
                reverse: true,
                controller: _scrollViewController,
                physics: const NeverScrollableScrollPhysics(),
                // physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      height: MediaQuery.of(context).size.height -
                          66 -
                          AppBar().preferredSize.height -
                          _bottomNavigationBarHeight,
                      child: chatProvider.selectedRoom!.chatList.isNotEmpty
                          ? const ChatScrollableList()
                          : const Center(child: Text('empty')),
                    ),
                    ChatBottomNavComponent(
                      room: chatProvider.selectedRoom!,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
