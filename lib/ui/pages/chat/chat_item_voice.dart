import 'dart:io';
import 'dart:math';
import 'package:chat_babakcode/constants/app_constants.dart';
import 'package:chat_babakcode/models/room.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/providers/login_provider.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chat_babakcode/models/chat.dart';
import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import '../../../providers/chat_provider.dart';
import 'package:detectable_text_field/detectable_text_field.dart' as detectable;
import '../../widgets/app_text.dart';

class ChatItemVoice extends StatefulWidget {
  final bool fromMyAccount;
  final ChatVoiceModel chat;
  final RoomType roomType;

  const ChatItemVoice(this.fromMyAccount, {Key? key, required this.chat, required this.roomType})
      : super(key: key);

  @override
  State<ChatItemVoice> createState() => _ChatItemVoiceState();
}

class _ChatItemVoiceState extends State<ChatItemVoice>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  final random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    final _chatProvider = context.read<ChatProvider>();

    return Column(
      crossAxisAlignment: widget.chat.user!.id == auth.myUser?.id
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
                  borderRadius: BorderRadius.circular(AppConstants.radiusCircular),
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
                            if (widget.chat.sendSuccessfully) {
                              fullPath =
                                  "${snapshot.data!.path}/${widget.chat.fileUrl!.split('/').last}";
                              exist = File(fullPath).existsSync();
                            } else {
                              final file =
                                  File.fromRawPath(widget.chat.fakeFile!);
                              exist = file.existsSync();
                              fullPath = file.path;
                            }
                            return Consumer<ChatProvider>(
                                builder: (context, chatProvider, child) {
                              if (widget.chat.downloadProgress != null &&
                                  widget.chat.downloadProgress! < 99) {
                                return CircularProgressIndicator(
                                  value: widget.chat.downloadProgress! / 100,
                                );
                              }
                              return widget.chat.sendSuccessfully
                                  ? IconButton(
                                      onPressed: () async {
                                        if (exist == false) {
                                          chatProvider.downloadFile(
                                              widget.chat.fileUrl!  + '/${auth.accessToken!}',
                                              fullPath,
                                              widget.chat);
                                        } else {
                                          widget.chat.isPlaying = true;
                                          chatProvider.notifyListeners();
                                          await widget.chat.audioPlayer
                                              .setFilePath(fullPath);
                                          _controller.forward();
                                          _controller.repeat();
                                          await widget.chat.audioPlayer.play();
                                          await widget.chat.audioPlayer.pause();
                                          _controller.stop();
                                          widget.chat.isPlaying = false;
                                          chatProvider.notifyListeners();
                                        }
                                      },
                                      icon: exist
                                          ? widget.chat.isPlaying
                                              ? const Icon(Icons.pause_rounded)
                                              : const Icon(
                                                  Icons.play_arrow_rounded)
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
                        widget.chat.isPlaying = true;
                        _chatProvider.notifyListeners();
                        await widget.chat.audioPlayer
                            .setUrl(widget.chat.fileUrl!  + '/${auth.accessToken!}');
                        _controller.forward();
                        _controller.repeat();
                        await widget.chat.audioPlayer.play();
                        await widget.chat.audioPlayer.pause();
                        _controller.stop();
                        widget.chat.isPlaying = false;
                        _chatProvider.notifyListeners();
                      }, icon:
                        Consumer<ChatProvider>(builder: (_, chatProvider, __) {
                        return widget.chat.isPlaying
                            ? const Icon(Icons.pause_rounded)
                            : const Icon(Icons.play_arrow_rounded);
                      })),
              ),
              Expanded(
                child: Column(
                  children: [
                    if(widget.roomType != RoomType.pvUser) Container(
                      width: double.infinity,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AppText(
                        widget.chat.user!.name!,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                      ),
                    ),
                    Lottie.asset(
                        'assets/json/equalizer_${
                            globalSetting.isDarkTheme
                                ? widget.fromMyAccount
                                ? 'light'
                                : 'dark'
                                : 'dark'}.json',
                        width: double.infinity,
                        height: 36,
                        controller: _controller, onLoaded: (composition) {
                      _controller
                        ..duration = composition.duration
                        ..value = random.nextInt(100) / 100;
                    }, animate: false, repeat: true, fit: BoxFit.fill),

                    // kIsWeb
                    //     ? Lottie.asset(
                    //         'assets/json/equalizer_${globalSetting.isDarkTheme ? 'light' : 'dark'}.json',
                    //         width: double.infinity,
                    //         height: 36,
                    //         controller: _controller, onLoaded: (composition) {
                    //         _controller
                    //           ..duration = composition.duration
                    //           ..value = random.nextInt(100) / 100;
                    //       }, animate: false, repeat: true, fit: BoxFit.fill)
                    //     : AppText(widget.chat.fileUrl, maxLines: 1, size: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Row(
                        mainAxisAlignment: widget.fromMyAccount
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            intl.DateFormat('HH:mm')
                                .format(widget.chat.utcDate ?? DateTime.now()),
                            style: TextStyle(
                                fontSize: 12,
                                color: globalSetting.isDarkTheme
                                    ? widget.fromMyAccount
                                        ? AppConstants.textColor[200]
                                        : AppConstants.textColor[700]
                                    : AppConstants.textColor[700]),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Icon(
                            widget.chat.sendSuccessfully
                                ? Icons.check_rounded
                                : Icons.access_time_rounded,
                            size: 8,
                            color: widget.fromMyAccount
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

        if (widget.chat.text != null)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: detectable.DetectableText(
              text: widget.chat.text ?? '',
              trimLines: 10,
              moreStyle: const TextStyle(color: Colors.blueGrey),
              lessStyle: const TextStyle(color: Colors.blueGrey),
              colorClickableText: Colors.blue,
              trimMode: detectable.TrimMode.Line,
              trimCollapsedText: 'more',
              trimExpandedText: '...less',
              onTap: (tappedText) {
                debugPrint('tappedText $tappedText');
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
                      ? widget.fromMyAccount
                      ? AppConstants.textColor[200]
                      : AppConstants.textColor[700]
                      : AppConstants.textColor[700]),
            ),
          ),

      ],
    );
  }
}
