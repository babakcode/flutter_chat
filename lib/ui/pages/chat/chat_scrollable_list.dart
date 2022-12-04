import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../../constants/app_constants.dart';
import '../../../models/chat.dart';
import '../../../models/room.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/global_setting_provider.dart';
import 'app_text_item.dart';

class ChatScrollableList extends StatefulWidget {
  const ChatScrollableList({Key? key}) : super(key: key);

  @override
  State<ChatScrollableList> createState() => _ChatScrollableListState();
}

class _ChatScrollableListState extends State<ChatScrollableList> {
  int? minInitIndex;

  @override
  void initState() {
    super.initState();
    _chatProvider = context.read<ChatProvider>();
    minInitIndex = _chatProvider.selectedRoom!.minViewPortSeenIndex;
    _selectedRoom = _chatProvider.selectedRoom!;
    _chatProvider.itemPositionsListener.itemPositions.addListener(_chatProvider.changeScrollIndexListener);
  }

  late ChatProvider _chatProvider;
  late Room _selectedRoom;

  @override
  void dispose() {
    _chatProvider.saveLastViewPortSeenIndex(_selectedRoom);
    _chatProvider.itemPositionsListener.itemPositions.removeListener(_chatProvider.changeScrollIndexListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Column(
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
            child: ScrollablePositionedList.builder(
              padding: const EdgeInsets.only(top: 100),
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemScrollController: chatProvider.itemScrollController,
              addAutomaticKeepAlives: true,
              initialScrollIndex: minInitIndex ?? 0,
              itemPositionsListener: chatProvider.itemPositionsListener,
              itemCount: chatProvider.selectedRoom!.chatList.length,
              itemBuilder: chatItem,
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
    );
  }

  Widget chatItem(BuildContext context, int index) {
    double _width = MediaQuery.of(context).size.width;

    final chatProvider = context.read<ChatProvider>();

    Room room = chatProvider.selectedRoom!;

    final chat = room.chatList[index];

    bool fromMyAccount = chat.user!.id == chatProvider.auth!.myUser!.id;
    bool previousChatFromUser = false;
    bool nextChatFromUser = false;
    bool middleChatFromUser = false;

    try {
      if(index != 0){
        previousChatFromUser = (room.chatList[index - 1].user!.id ==
            chatProvider.auth!.myUser!.id) ==
            fromMyAccount;
      }
      if(index != (room.chatList.length - 1)){
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
            child: AppChatItem(index, fromMyAccount, previousChatFromUser,
                nextChatFromUser, middleChatFromUser),
          ),
        ],
      ),
    );
  }
}
