import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_babakcode/models/chat.dart';
import 'package:chat_babakcode/ui/pages/zoom_image/zoom_image_page.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:detectable_text_field/detectable_text_field.dart' as detectable;
import '../../../constants/app_constants.dart';
import '../../../models/room.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/global_setting_provider.dart';
import '../../widgets/app_text.dart';

class ChatItemPhoto extends StatelessWidget {
  final bool fromMyAccount;
  final ChatPhotoModel chat;
  final RoomType roomType;

  const ChatItemPhoto(this.fromMyAccount, {Key? key, required this.chat, required this.roomType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalSettingProvider = context.read<GlobalSettingProvider>();
    final chatProvider = context.read<ChatProvider>();
    final auth = context.read<Auth>();

    return InkWell(
      onTap: () {
        if (chat.sendSuccessfully) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ZoomImagePage(
                    imageUrl: chat.fileUrl! + '/${auth.accessToken!}'),
              ));
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            fromMyAccount ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: chat.sendSuccessfully
                    ? CachedNetworkImage(imageUrl: chat.fileUrl! + '/${auth.accessToken!}',
                        width: double.infinity, fit: BoxFit.cover,
                        errorWidget: (context, error, stackTrace) {
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
                                  Icon(Icons
                                      .wifi_tethering_error_rounded_rounded)
                                ],
                              ),
                            ),
                          ),
                        );
                      }, progressIndicatorBuilder: (context, url, loadingProgress) {
                        // if (loadingProgress.progress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.progress,
                          ),
                        );
                      })
                    : Image.memory(chat.fakeFile!,
                        width: double.infinity, fit: BoxFit.cover,
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
                                  Icon(Icons
                                      .wifi_tethering_error_rounded_rounded)
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
              ),
              if (!chat.sendSuccessfully)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if(roomType != RoomType.pvUser) Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: AppText(
                  chat.user!.name!,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                ),
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
      ),
    );
  }
}
