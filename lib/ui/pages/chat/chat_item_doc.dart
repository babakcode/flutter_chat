import 'dart:io';
import 'package:chat_babakcode/constants/app_constants.dart';
import 'package:chat_babakcode/constants/config.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/providers/login_provider.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chat_babakcode/models/chat.dart';
import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import '../../../providers/chat_provider.dart';
import 'package:detectable_text_field/detectable_text_field.dart' as detectable;
import '../../widgets/app_text.dart';

class ChatItemDoc extends StatelessWidget {
  final bool fromMyAccount;
  final ChatDocModel chat;

  const ChatItemDoc(this.fromMyAccount, {Key? key, required this.chat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _widthChatPageSection = MediaQuery.of(context).size.width;
    if (_widthChatPageSection > 960) {
      _widthChatPageSection -= 260;
    }
    if (_widthChatPageSection > 600) {
      _widthChatPageSection -= 340;
    }
    final auth = context.read<Auth>();
    final globalSetting = context.watch<GlobalSettingProvider>();

    return Column(
      crossAxisAlignment: chat.user!.id == auth.myUser?.id
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _widthChatPageSection > 400 ? 360 : _widthChatPageSection * .8,
          child: Row(
            children: [
              Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: globalSetting.isDarkTheme
                    ? AppConstants.textColor
                    : AppConstants.textColor[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConfig.radiusCircular),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: LoginProvider.platform == 'android' ||
                        LoginProvider.platform == 'ios'
                    ? FutureBuilder<Directory>(
                        future: getApplicationDocumentsDirectory(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            bool exist = false;
                            String fullPath = '';
                            if (chat.sendSuccessfully) {
                              fullPath =
                                  "${snapshot.data!.path}/${chat.fileUrl!.split('/').last}";
                              exist = File(fullPath).existsSync();
                            } else {
                              final file = File.fromRawPath(chat.fakeFile!);
                              exist = file.existsSync();
                              fullPath = file.path;
                            }
                            return Consumer<ChatProvider>(
                                builder: (context, chatProvider, child) {
                              if (chat.downloadProgress != null &&
                                  chat.downloadProgress! < 99) {
                                return CircularProgressIndicator(
                                  value: chat.downloadProgress! / 100,
                                );
                              }
                              return chat.sendSuccessfully
                                  ? IconButton(
                                      onPressed: () async {
                                        if (exist == false) {
                                          chatProvider.downloadFile(
                                              chat.fileUrl! +
                                                  '/${auth.accessToken!}',
                                              fullPath,
                                              chat);
                                        } else {
                                          print('file open clicked');
                                          OpenFile.open(fullPath);
                                        }
                                      },
                                      icon: exist
                                          ? const Icon(
                                              Icons.file_present_rounded)
                                          : const Icon(Icons.download_rounded),
                                    )
                                  : SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: Stack(
                                        children: const [
                                          Icon(Icons.upload_rounded),
                                          CircularProgressIndicator()
                                        ],
                                      ),
                                    );
                            });
                          }
                          return const CircularProgressIndicator();
                        })
                    : IconButton(onPressed: () async {
                        // await launchUrl(Uri.parse(chat.fileUrl!));
                    if(kIsWeb){
                      /// todo : before release on web uncomment following line
                      // WebDownloadService.openInANewTab(chat.fileUrl! + '/${auth.accessToken!}');
                    }
                  // OpenFile.open(chat.fileUrl!);
                      }, icon:
                        Consumer<ChatProvider>(builder: (_, chatProvider, __) {
                        return const Icon(Icons.file_present_rounded);
                      })),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AppText(
                        chat.user!.name!,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                      ),
                    ),
                    AppText(chat.fileUrl ?? 'document sending...',
                        maxLines: 1, size: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        mainAxisAlignment: fromMyAccount
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            intl.DateFormat('HH:mm')
                                .format(chat.utcDate ?? DateTime.now()),
                            style: TextStyle(
                                fontSize: 12,
                                color: globalSetting.isDarkTheme
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
                            size: 8,
                            color: fromMyAccount
                                ? AppConstants.textColor[200]
                                : AppConstants.textColor[700],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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
                  color: globalSetting.isDarkTheme
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
