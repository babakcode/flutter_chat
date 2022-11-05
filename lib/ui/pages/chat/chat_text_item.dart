import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';

class ChatTextItem extends StatelessWidget {
  final int index;
  final bool fromMyAccount,
      previusChatFromUser,
      nextChatFromUser,
      middleChatFromUser;
  const ChatTextItem(this.index, this.fromMyAccount, this.previusChatFromUser,
      this.nextChatFromUser, this.middleChatFromUser,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final globalSettingProvider = context.watch<GlobalSettingProvider>();

    var borders = BorderRadius.only(
          topLeft: middleChatFromUser
              ? const Radius.circular(6)
              : previusChatFromUser
                  ? const Radius.circular(16)
                  : const Radius.circular(6),
          topRight: middleChatFromUser
              ? const Radius.circular(6)
              : nextChatFromUser
                  ? const Radius.circular(6)
                  : const Radius.circular(16),
          bottomLeft: const Radius.circular(6),
          bottomRight: middleChatFromUser
              ? const Radius.circular(6)
              : nextChatFromUser
                  ? const Radius.circular(16)
                  : const Radius.circular(6),
        );
        
    if(fromMyAccount){
      borders = BorderRadius.only(
        bottomLeft: borders.bottomRight,
        bottomRight: borders.bottomLeft,
        topLeft: borders.topRight,
        topRight: borders.topLeft
      );
    }

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
      child: Text(
        "The [The [overflow] property's behavior is affected by the [softWrap] argument. If the [softWrap] is true or null, the glyph causing overflow, and those that follow, will not be rendered. Otherwise, it will be shown with the given overflow option. awdaawdaawdd awdawd wa",
        style: TextStyle(
            color: globalSettingProvider.isDarkTheme ? 
            fromMyAccount
                ? AppConstants.textColor[200] :
                AppConstants.textColor[700]
                : AppConstants.textColor[700]),
      ),
    );
  }
}
