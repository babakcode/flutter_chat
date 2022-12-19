import 'package:chat_babakcode/ui/pages/chat/chat_item_photo.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_item_text.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_item_update_required.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/widgets/app_button_transparent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_constants.dart';
import '../../../models/chat.dart';
import '../../../models/room.dart';
import '../../../providers/chat_provider.dart';
import '../../../utils/utils.dart';
import '../../widgets/app_text.dart';
import 'chat_item_doc.dart';
import 'chat_item_voice.dart';

class AppChatItem extends StatelessWidget {
  final int index;
  final bool fromMyAccount,
      previousChatFromUser,
      nextChatFromUser,
      middleChatFromUser;

  const AppChatItem(this.index, this.fromMyAccount, this.previousChatFromUser,
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
        bottomRight: const Radius.circular(16));

    if (fromMyAccount) {
      borders = BorderRadius.only(
          bottomLeft: borders.bottomRight,
          bottomRight: borders.bottomLeft,
          topLeft: borders.topRight,
          topRight: borders.topLeft);
    }

    final chatProvider = context.read<ChatProvider>();

    final Room room = chatProvider.selectedRoom!;
    Chat chat = room.chatList[index];

    return Container(
      padding: const EdgeInsets.all(4),
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
      child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
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
          // padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: fromMyAccount
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (chat.replyId != null)
                AppButtonTransparent(
                  onPressed: () => chatProvider.scrollToReply(chat.replyId!),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!fromMyAccount)
                        const SizedBox(
                            height: 30,
                            width: 10,
                            child: VerticalDivider(
                              color: Colors.blue,
                              thickness: 2,
                              width: 0,
                            )),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: fromMyAccount
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            chat.replyId!.user!.name!,
                            style: const TextStyle(color: Colors.blueGrey, fontSize: 12),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          AppText(Utils.displayLastChat(chat.replyId!),
                              color: globalSettingProvider.isDarkTheme
                                  ? fromMyAccount
                                  ? AppConstants.textColor[200]
                                  : AppConstants.textColor[700]
                                  : AppConstants.textColor[700],)
                        ],
                      ),
                      if (fromMyAccount)
                        const SizedBox(
                            height: 30,
                            width: 10,
                            child: VerticalDivider(
                              color: Colors.blue,
                              thickness: 2,
                              width: 0,
                            )),
                    ],
                  ),
                ),
              Builder(
                builder: (context) {
                  if (chat is ChatTextModel) {
                    return ChatItemText(
                      fromMyAccount,
                      chat: chat,
                      roomType: room.roomType!,
                    );
                  } else if (chat is ChatPhotoModel) {
                    return ChatItemPhoto(
                      fromMyAccount,
                      chat: chat,
                      roomType: room.roomType!,
                    );
                  } else if (chat is ChatVoiceModel) {
                    return ChatItemVoice(
                      fromMyAccount,
                      chat: chat,
                      roomType: room.roomType!,
                    );
                  } else if (chat is ChatDocModel) {
                    return ChatItemDoc(
                      fromMyAccount,
                      chat: chat,
                      roomType: room.roomType!,
                    );
                  }
                  return ChatItemUpdateRequired(fromMyAccount);
                },
              ),
            ],
          )),
    );
  }
}
