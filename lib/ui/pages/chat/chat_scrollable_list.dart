import 'package:chat_babakcode/models/chat.dart';
import 'package:chat_babakcode/ui/pages/profile/profile_user_page.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:chat_babakcode/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../constants/app_constants.dart';
import '../../../models/room.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/global_setting_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_button_transparent.dart';
import 'app_text_item.dart';
import 'package:swipe_to/swipe_to.dart';

final _bucket = PageStorageBucket();

class ChatScrollableList extends StatefulWidget {
  const ChatScrollableList({Key? key}) : super(key: key);

  @override
  State<ChatScrollableList> createState() => _ChatScrollableListState();
}

class _ChatScrollableListState extends State<ChatScrollableList> {
  @override
  void initState() {
    super.initState();
    _chatProvider = context.read<ChatProvider>();
    _selectedRoom = _chatProvider.selectedRoom!;
    _chatProvider.itemPositionsListener.itemPositions
        .addListener(_chatProvider.changeScrollIndexListener);

    if (_selectedRoom.firstOpenRoom) {
      if (_selectedRoom.chatList.length > 16) {
        _selectedRoom.firstOpenRoom = false;
      }
      try {
        Future.microtask(() => _chatProvider.itemScrollController
            .jumpTo(index: _chatProvider.selectedRoom!.minViewPortSeenIndex));
      } catch (e) {
        if (kDebugMode) {
          print('exception #005 $e');
        }
      }
    }
  }

  late ChatProvider _chatProvider;
  late Room _selectedRoom;

  @override
  void dispose() {
    _chatProvider.saveLastViewPortSeenIndex(_selectedRoom);

    _chatProvider.itemPositionsListener.itemPositions
        .removeListener(_chatProvider.changeScrollIndexListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return PageStorage(
      bucket: _bucket,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (chatProvider.loadingLoadMorePrevious)
            SizedBox(
              child: LinearProgressIndicator(
                backgroundColor: AppConstants.blueAccent,
              ),
              width: 80,
            ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // if(notification.metrics.maxScrollExtent > 0){
                  //   if(!_selectedRoom.canScrollList){
                  //     print('can scroll');
                  //     _selectedRoom.canScrollList = true;
                  //     notification;
                  //   }
                  // }
                  if (kIsWeb) {
                    return true;
                  }
                  if (notification is ScrollEndNotification) {
                    _chatProvider.saveLastViewPortSeenIndex(_selectedRoom);
                  }
                  return true;
                },
                child: ScrollablePositionedList.builder(
                  key: _selectedRoom.chatList.length > 16
                      ? PageStorageKey<String>(_selectedRoom.id!)
                      : null,
                  padding: const EdgeInsets.only(top: 100),
                  scrollDirection: Axis.vertical,
                  itemScrollController: chatProvider.itemScrollController,
                  addAutomaticKeepAlives: true,
                  shrinkWrap: true,
                  // initialScrollIndex: minInitIndex ?? 0,
                  itemPositionsListener: chatProvider.itemPositionsListener,
                  itemCount: chatProvider.selectedRoom!.chatList.length,
                  itemBuilder: chatItem,
                ),
              ),
            ),
          ),
          if (chatProvider.loadingLoadMoreNext)
            SizedBox(
              child: LinearProgressIndicator(
                backgroundColor: AppConstants.blueAccent,
              ),
              width: 80,
            ),
        ],
      ),
    );
  }

  Widget chatItem(BuildContext context, int index) {
    final _width = MediaQuery.of(context).size.width;

    final chatProvider = context.watch<ChatProvider>();
    final globalSettingProvider = context.watch<GlobalSettingProvider>();

    final room = chatProvider.selectedRoom!;

    final chat = room.chatList[index];

    bool fromMyAccount = chat.user!.id == chatProvider.auth!.myUser!.id;
    bool previousChatFromUser = false;
    bool nextChatFromUser = false;
    bool middleChatFromUser = false;

    try {
      if (index != 0) {
        previousChatFromUser = (room.chatList[index - 1].user!.id ==
                chatProvider.auth!.myUser!.id) ==
            fromMyAccount;
      }
      if (index != (room.chatList.length - 1)) {
        nextChatFromUser = (room.chatList[index + 1].user!.id ==
                chatProvider.auth!.myUser!.id) ==
            fromMyAccount;
      }
      middleChatFromUser = (previousChatFromUser && nextChatFromUser);
    } catch (e) {
      if (kDebugMode) {
        print('chatItem in $index index exception : $e');
      }
    }

    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return chatActionDialog(globalSettingProvider, fromMyAccount, index,
                chatProvider, context, chat);
          },
        );
      },
      child: SwipeTo(
        onLeftSwipe: () {
          _chatProvider.enableChatReplay(index);
        },
        onRightSwipe: () {
          _chatProvider.enableChatReplay(index);
        },
        child: Container(
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
          alignment:
              fromMyAccount ? Alignment.bottomRight : Alignment.bottomLeft,
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
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          ProfileUserPage(user: chat.user!),
                                    ),
                                  );
                                },
                                child: chat.user?.profileUrl == null
                                    ? Image.asset(
                                        'assets/images/p2.jpg',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        chat.user!.profileUrl!,
                                        fit: BoxFit.cover,
                                      )),
                          ),
                  ),
                ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: _width *
                      (GlobalSettingProvider.isPhonePortraitSize ? .8 : .3),
                ),
                child: AppChatItem(index, fromMyAccount, previousChatFromUser,
                    nextChatFromUser, middleChatFromUser),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget chatActionDialog(
    GlobalSettingProvider globalSettingProvider,
    bool isMyMessage,
    int index,
    ChatProvider _chatProvider,
    BuildContext context,
    Chat chat) {
  String? copyTextContent;
  if (chat is ChatTextModel) {
    copyTextContent = chat.text;
  } else if (chat is ChatPhotoModel) {
    copyTextContent = chat.text;
  } else if (chat is ChatDocModel) {
    copyTextContent = chat.text;
  } else if (chat is ChatVoiceModel) {
    copyTextContent = chat.text;
  }
  return Dialog(
    backgroundColor: globalSettingProvider.isDarkTheme
        ? AppConstants.scaffoldDarkBackground
        : AppConstants.scaffoldLightBackground,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusCircular)),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const AppText('Reply text'),
              onTap: () {
                _chatProvider.enableChatReplay(index);
                Navigator.pop(context);
              },
            ),
            if (copyTextContent != null)
              ListTile(
                title: const AppText('Copy text'),
                onTap: () {
                  Utils.coptText(copyTextContent!);
                  Navigator.pop(context);
                },
              ),
            if (isMyMessage)
              ListTile(
                title: const AppText(
                  'Delete text',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () {
                  _chatProvider.emitAction('deleteChat', chat.id);
                  Navigator.pop(context);
                },
              )
          ],
        ),
      ),
    ),
  );
}
//3f782171543144e6a06f00f46f95865ea52b8bca8519a90a6e294c2a79d2a4de rubbed-highway-balloon-position-snow-stock-whale-stiff-whatever-worse-lunch-turn-spider-daughter-fun-hole
