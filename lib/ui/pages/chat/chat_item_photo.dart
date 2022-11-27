
import 'package:chat_babakcode/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import '../../../constants/app_constants.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/global_setting_provider.dart';

class ChatItemPhoto extends StatelessWidget {
  final bool fromMyAccount;
  final ChatPhotoModel chat;
  const ChatItemPhoto(this.fromMyAccount, {Key? key,required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalSettingProvider = context.read<GlobalSettingProvider>();
    final chatProvider = context.read<ChatProvider>();


    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
      fromMyAccount ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Image.network(chat.fileUrl,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: InkWell(
                      onTap: () => chatProvider.refreshPage(chatProvider.selectedRoom!),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('download failed, try again'),
                            SizedBox(width: 5,),
                            Icon(Icons.wifi_tethering_error_rounded_rounded)
                          ],
                        ),
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                }),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: globalSettingProvider.isDarkTheme
                      ? fromMyAccount
                      ? AppConstants.textColor[700]!.withOpacity(.4)
                      : AppConstants.textColor[200]!.withOpacity(.4)
                      : AppConstants.textColor[200]!.withOpacity(.4),
                ),
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.all(12),
                child: Text(
                  intl.DateFormat('HH:mm').format(chat.utcDate ?? DateTime.now()),
                  style: TextStyle(
                      fontSize: 12,
                      color: globalSettingProvider.isDarkTheme
                          ? fromMyAccount
                          ? AppConstants.textColor[200]
                          : AppConstants.textColor[700]
                          : AppConstants.textColor[700]),
                ),
              ),
            ),
          ],
        ),
        if (chat.text != null)
          Text(
            chat.text!,
            style: TextStyle(
                color: globalSettingProvider.isDarkTheme
                    ? fromMyAccount
                    ? AppConstants.textColor[200]
                    : AppConstants.textColor[700]
                    : AppConstants.textColor[700]),
          )
      ],
    );
  }
}