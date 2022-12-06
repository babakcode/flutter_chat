import 'package:chat_babakcode/models/chat.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:detectable_text_field/detectable_text_field.dart' as detectable;
import '../../../constants/app_constants.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/global_setting_provider.dart';

class ChatItemPhoto extends StatelessWidget {
  final bool fromMyAccount;
  final ChatPhotoModel chat;

  const ChatItemPhoto(this.fromMyAccount, {Key? key, required this.chat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalSettingProvider = context.read<GlobalSettingProvider>();
    final chatProvider = context.read<ChatProvider>();
    final auth = context.read<Auth>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          fromMyAccount ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              constraints: const BoxConstraints(
                maxHeight: 300
              ),
              child: chat.sendSuccessfully
                  ? Image.network(chat.fileUrl! + '/${auth.accessToken!}',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: InkWell(
                        onTap: () => chatProvider
                            .refreshPage(chatProvider.selectedRoom!),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('download failed, try again'),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.wifi_tethering_error_rounded_rounded)
                            ],
                          ),
                        ),
                      ),
                    );
                  }, loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  })
                  : Image.memory(chat.fakeFile!,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: InkWell(
                        onTap: () => chatProvider
                            .refreshPage(chatProvider.selectedRoom!),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('download failed, try again'),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.wifi_tethering_error_rounded_rounded)
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
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
              ),
            ),
          ],
        ),
        if (chat.text != null)
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
      ],
    );
  }
}
