import 'package:chat_babakcode/models/chat.dart';
import 'package:chat_babakcode/models/room.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import '../../../constants/app_constants.dart';
import '../../../providers/global_setting_provider.dart';
import '../../widgets/app_detectable_text.dart';
import '../../widgets/app_text.dart';

class ChatItemText extends StatelessWidget {
  final bool fromMyAccount;
  final ChatTextModel chat;
  final RoomType roomType;

  const ChatItemText(this.fromMyAccount,
      {Key? key, required this.chat, required this.roomType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalSettingProvider = context.read<GlobalSettingProvider>();

    return InkWell(
      onTap: null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            fromMyAccount ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (roomType != RoomType.pvUser)
            Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AppText(
                chat.user!.name!,
                fontWeight: FontWeight.bold,
                maxLines: 1,
              ),
            ),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: AppDetectableText(
                chat.text ?? '',
                textColor: globalSettingProvider.isDarkTheme
                    ? fromMyAccount
                        ? AppConstants.textColor[200]
                        : AppConstants.textColor[700]
                    : AppConstants.textColor[700],
              ),),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  intl.DateFormat('HH:mm')
                      .format(chat.utcDate ?? DateTime.now()),
                  style: TextStyle(
                      fontSize: 12,
                      color: globalSettingProvider.isDarkTheme
                          ? fromMyAccount
                              ? AppConstants.textColor[200]
                              : AppConstants.textColor[700]
                          : AppConstants.textColor[700]),
                ),
                const SizedBox(
                  width: 4,
                ),
                Icon(
                  chat.sendSuccessfully
                      ? Icons.check_rounded
                      : Icons.access_time_rounded,
                  size: 10,
                  color: fromMyAccount
                      ? AppConstants.textColor[200]
                      : AppConstants.textColor[700],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
