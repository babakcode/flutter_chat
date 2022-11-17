import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import '../../../constants/app_constants.dart';
import '../../../models/chat.dart';
import '../../../models/room.dart';
import '../../../providers/chat_provider.dart';

class ChatTextItem extends StatelessWidget {
  final int index;
  final bool fromMyAccount,
      previousChatFromUser,
      nextChatFromUser,
      middleChatFromUser;
  const ChatTextItem(this.index, this.fromMyAccount, this.previousChatFromUser,
      this.nextChatFromUser, this.middleChatFromUser,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final globalSettingProvider = context.watch<GlobalSettingProvider>();

    var borders = BorderRadius.only(
          topLeft: previousChatFromUser
                  ? const Radius.circular(6)
                  : const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: const Radius.circular(6),
          bottomRight: const Radius.circular(16)
        );
        
    if(fromMyAccount){
      borders = BorderRadius.only(
        bottomLeft: borders.bottomRight,
        bottomRight: borders.bottomLeft,
        topLeft: borders.topRight,
        topRight: borders.topLeft
      );
    }


    final chatProvider = context.read<ChatProvider>();

    final Room room = chatProvider.selectedRoom!;
    Chat chat = room.chatList.get(index);


    return Container(
      decoration: BoxDecoration(
        borderRadius: borders,
        color: globalSettingProvider.isDarkTheme
            ? fromMyAccount
                ? AppConstants.textColor[700]
                : AppConstants.textColor[300]
            : fromMyAccount
                ? AppConstants.textColor[50]
                : AppConstants.textColor[200],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: fromMyAccount ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            chat.text ?? ''
            ,style: TextStyle(
                color: globalSettingProvider.isDarkTheme ? 
                fromMyAccount
                    ? AppConstants.textColor[200] :
                    AppConstants.textColor[700]
                    : AppConstants.textColor[700]),
          ),
          Text(intl.DateFormat('HH:mm').format(chat.utcDate ?? DateTime.now())
            ,style: TextStyle(
              fontSize: 12,
                color: globalSettingProvider.isDarkTheme ?
                fromMyAccount
                    ? AppConstants.textColor[200] :
                AppConstants.textColor[700]
                    : AppConstants.textColor[700]),
          )
        ],
      ),
    );
  }
}
