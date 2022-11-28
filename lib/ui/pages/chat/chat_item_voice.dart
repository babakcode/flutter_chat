import 'dart:io';

import 'package:path_provider/path_provider.dart' ;
import 'package:chat_babakcode/models/chat.dart';
import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart' as intl;
import '../../../providers/chat_provider.dart';

class ChatItemVoice extends StatefulWidget {
  final bool fromMyAccount;
  final ChatVoiceModel chat;
  const ChatItemVoice(this.fromMyAccount, {Key? key,required this.chat}) : super(key: key);

  @override
  State<ChatItemVoice> createState() => _ChatItemVoiceState();
}

class _ChatItemVoiceState extends State<ChatItemVoice> {
  @override
  Widget build(BuildContext context) {

    final auth = context.read<Auth>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment:
        widget.chat.user!.id == auth.myUser?.id
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            widget.chat.user!.name!,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            width: 270,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade50,
                  ),
                  child: FutureBuilder<Directory>(
                      future: getApplicationDocumentsDirectory(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          String fullPath =
                              "${snapshot.data!.path}/${widget.chat.fileUrl}";
                          bool exist = File(fullPath).existsSync();
                          return Consumer<ChatProvider>(
                              builder: (context, chatProvider, child) {
                                if (widget.chat.downloadProgress !=
                                    null &&
                                    widget.chat.downloadProgress! < 99) {
                                  return CircularProgressIndicator(
                                    value:
                                    widget.chat.downloadProgress! /
                                        100,
                                  );
                                }
                                return IconButton(
                                  onPressed: () async {
                                    if (exist == false) {
                                      chatProvider.downloadImage(
                                          '/${widget.chat.fileUrl}',
                                          fullPath,
                                          widget.chat);
                                    } else {
                                      widget.chat.isPlaying = true;
                                      chatProvider.notifyListeners();
                                      await widget.chat.audioPlayer
                                          .setFilePath(fullPath);
                                      await widget.chat.audioPlayer
                                          .play();
                                      await widget.chat.audioPlayer
                                          .pause();
                                      widget.chat.isPlaying = false;
                                      chatProvider.notifyListeners();
                                    }
                                  },
                                  icon: exist
                                      ? widget.chat.isPlaying
                                      ? const Icon(Icons.pause)
                                      : const Icon(Icons.play_arrow)
                                      : const Icon(Icons.download),
                                );
                              });
                        }
                        return const CircularProgressIndicator();
                      }),
                ),
                Expanded(
                    child: Text(
                      widget.chat.fileUrl ?? '',
                      maxLines: 1,
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            intl.DateFormat('HH:mm')
                .format(widget.chat.utcDate!)
                .toString(),
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
