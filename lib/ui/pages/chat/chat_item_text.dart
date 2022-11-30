import 'package:chat_babakcode/models/chat.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:detectable_text_field/detectable_text_field.dart' as detectable;
import 'package:intl/intl.dart' as intl;
import '../../../constants/app_constants.dart';
import '../../../providers/global_setting_provider.dart';

class ChatItemText extends StatelessWidget {
  final bool fromMyAccount;
  final ChatTextModel chat;

  const ChatItemText(this.fromMyAccount, {Key? key, required this.chat})
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: detectable.DetectableText(
              text: chat.text ?? '',
              trimLines: 10,
              moreStyle: const TextStyle(color: Colors.blueGrey),
              lessStyle: const TextStyle(color: Colors.blueGrey),
              colorClickableText: Colors.blue,
              trimMode: detectable.TrimMode.Line,
              trimCollapsedText: 'more',
              trimExpandedText: '...less',
              onTap: (tappedText) {
                debugPrint(tappedText);
                if (tappedText.startsWith('#')) {
                  debugPrint('DetectableText >>>>>>> #');
                } else if (tappedText.startsWith('@')) {
                  debugPrint('DetectableText >>>>>>> @');
                } else if (tappedText.startsWith('http')) {
                  debugPrint('DetectableText >>>>>>> http');
                }
              },
              detectionRegExp: hashTagAtSignUrlRegExp,
              basicStyle: TextStyle(
                  color: globalSettingProvider.isDarkTheme
                      ? fromMyAccount
                          ? AppConstants.textColor[200]
                          : AppConstants.textColor[700]
                      : AppConstants.textColor[700]),
            ),
          ),
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
