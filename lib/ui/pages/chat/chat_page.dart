import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_bottom_nav.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_text_item.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../models/chat.dart';
import '../../../models/chat_appbar_model.dart';
import '../../../models/room.dart';
import '../../../models/user.dart';
import '../../../providers/auth_provider.dart';

PageStorageBucket bucket = PageStorageBucket();

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // ChatProvider? chatProvider;
  @override
  void initState() {
    super.initState();
    _canPop = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
  }

  @override
  void dispose() {
    // chatProvider!.itemPositionsListener.itemPositions.removeListener(chatProvider!.changeScrollIndexListener);
    super.dispose();
    print('dispose');
  }

  bool _canPop = true;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    ChatProvider chatProvider = Provider.of(context);
    final auth = context.read<Auth>();

    Room? room = chatProvider.selectedRoom;
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

    if(room != null){
      switch (room.roomType) {
        case RoomType.pvUser:

          if(room.members![0].user!.id == auth.myUser!.id && room.members![1].user!.id == auth.myUser!.id){
            chatAppBarModel
              ..roomName = 'my Messages'
              ..roomImage = auth.myUser!.profileUrl
              ..roomType = RoomType.pvUser;
            break;
          }

          User friend = room.members!
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
    // List<Chat> _chatList = room?.chatList ?? [];

    if ((room == null)) {
      return const Scaffold(
        body: Center(child: AppText('please select chat room')),
      );
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
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
          physics: const NeverScrollableScrollPhysics(),
          controller: ScrollController(),
          reverse: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PageStorage(
                bucket: bucket,
                child: SizedBox(
                  // alignment: Alignment.bottomCenter,
                  height: MediaQuery.of(context).size.height - 120,
                  child: ScrollablePositionedList.builder(
                    // key: PageStorageKey('${room.id}'),
                    addAutomaticKeepAlives: true,
                    scrollDirection: Axis.vertical,
                    // initialScrollIndex: room.roomPositionIndex!.max,
                    itemPositionsListener: chatProvider.itemPositionsListener,
                    itemScrollController: chatProvider.itemScrollController,
                    itemCount: room.chatList.length,
                    itemBuilder: chatItem,
                  ),
                ),
              ),
              ChatBottomNavComponent(
                room: room,
              )
            ],
          ),
        ),
      );
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
