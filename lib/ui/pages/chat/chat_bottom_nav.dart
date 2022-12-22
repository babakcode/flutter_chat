import 'package:chat_babakcode/constants/app_constants.dart';
import 'package:chat_babakcode/models/room.dart';
import 'package:chat_babakcode/models/user.dart';
import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/providers/login_provider.dart';
import 'package:chat_babakcode/ui/widgets/app_button_transparent.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../models/chat.dart';
import '../../../providers/search_user_provider.dart';
import '../../../utils/utils.dart';
import '../../widgets/app_text.dart';

class ChatBottomNavComponent extends StatefulWidget {
  final Room room;

  const ChatBottomNavComponent({super.key, required this.room});

  @override
  State<ChatBottomNavComponent> createState() => _ChatBottomNavComponentState();
}

class _ChatBottomNavComponentState extends State<ChatBottomNavComponent> {
  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final globalSetting = context.watch<GlobalSettingProvider>();

    var _width = MediaQuery.of(context).size.width;
    if (_width > 960) {
      _width -= 260;
    }
    if (_width > 600) {
      _width -= 340;
    }

    bool checkUserCanNotSendChatToThisRoom = widget.room.members == null;

    return Card(
      elevation: 20,
      margin: EdgeInsets.zero,
      color: globalSetting.isDarkTheme
          ? AppConstants.textColor[900]
          : AppConstants.textColor[50],
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(
        children: [
          checkUserCanNotSendChatToThisRoom // check blocked
              ? const Card(
                  margin: EdgeInsets.zero,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text('Mute Channel'),
                    ),
                  ),
                )
              : Column(
                  children: [
                    /// pre send files section
                    _preSendFilesOffstageSection(
                        chatProvider, globalSetting, _width),

                    /// for search `@users`
                    //_atSignSection(chatProvider),

                    /// for replay chat
                    _replyOffStateSection(chatProvider),

                    /// for edit chat
                    _editOffStateSection(chatProvider),

                    /// input box
                    /// emoji + chat + attachment + send chat card
                    _chatInputSection(context),
                    // divider between the input box and the following offstages
                    Center(
                      child: SizedBox(
                          child: Divider(
                              height: 1,
                              color: globalSetting.isDarkTheme
                                  ? AppConstants.textColor[600]
                                  : AppConstants.textColor[100])),
                    ),

                    /// show emoji offstage
                    _emojiOffstageSection(chatProvider, globalSetting),

                    /// show share file, image, video, camera captured image, etc
                    _attachmentOffstageSection(
                        chatProvider, globalSetting, _width)
                  ],
                ),
        ],
      ),
    );
  }

  Widget _chatInputSection(BuildContext context) {
    final chatProvider = context.read<ChatProvider>();
    final globalSetting = context.read<GlobalSettingProvider>();
    final searchAtSignUserProvider = context.read<SearchUserProvider>();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Card(
            elevation: 0,
            margin: const EdgeInsets.all(6),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              onTap: chatProvider.emojiToggle,
              child: const SizedBox(
                  height: 36,
                  width: 36,
                  child: Icon(Icons.emoji_emotions_outlined)),
            ),
          ),
          // AnimatedSize(
          //   duration:
          //       const Duration(milliseconds: 300),
          //   curve: Curves.fastOutSlowIn,
          //   child: Container(
          //     child: chatProvider.showSendChat
          //         ? null
          //         : Card(
          //             elevation: 0,
          //             color: globalSetting
          //                     .isDarkTheme
          //                 ? AppConstants
          //                     .textColor[900]
          //                 : AppConstants
          //                     .scaffoldLightBackground,
          //             margin: const EdgeInsets
          //                 .symmetric(vertical: 6),
          //             shape: RoundedRectangleBorder(
          //                 borderRadius:
          //                     BorderRadius.circular(
          //                         14)),
          //             clipBehavior: Clip
          //                 .antiAliasWithSaveLayer,
          //             child: InkWell(
          //               onTap: chatProvider
          //                   .emojiToggle,
          //               child: const SizedBox(
          //                   height: 36,
          //                   width: 36,
          //                   child: Icon(Icons
          //                       .emoji_food_beverage_outlined)),
          //             ),
          //           ),
          //   ),
          // ),
          Expanded(
            child: DetectableTextField(
              detectionRegExp: hashTagAtSignUrlRegExp,
              minLines: 1,
              onDetectionFinished: searchAtSignUserProvider.onDetectionFinished,
              onDetectionTyped: searchAtSignUserProvider.onDetectionTyped,
              focusNode: chatProvider.chatFocusNode,
              controller: chatProvider.chatController,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'^[ ]')),
              ],
              maxLines: 6,
              decoration: const InputDecoration(
                  hintText: "Message", border: InputBorder.none),
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            child: Container(
              child: chatProvider.showSendChat
                  ? null
                  : Card(
                      elevation: 0,
                      color: globalSetting.isDarkTheme
                          ? AppConstants.textColor[600]
                          : AppConstants.scaffoldLightBackground,
                      margin: const EdgeInsets.all(6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: InkWell(
                        onTap: chatProvider.shareFileToggle,
                        child: const SizedBox(
                          height: 36,
                          width: 36,
                          child: Icon(
                            Icons.attach_file_outlined,
                          ),
                        ),
                      ),
                    ),
            ),
          ),

          GestureDetector(
            onTap: () => chatProvider.emitChat(widget.room),
            onLongPress: () => chatProvider.recordStart(),
            onLongPressEnd: (s) =>
                chatProvider.recordStop(context, widget.room),
            child: Card(
              elevation: 0,
              color: globalSetting.isDarkTheme
                  ? AppConstants.textColor[50]
                  : AppConstants.textColor[800],
              margin: const EdgeInsets.all(2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(
                    chatProvider.pressedOnRecordButton
                        ? Icons.circle
                        : chatProvider.showSendChat ||
                                chatProvider.showPreUploadFile
                            ? Icons.send
                            : Icons.keyboard_voice_rounded,
                    color: chatProvider.pressedOnRecordButton
                        ? Colors.red
                        : globalSetting.isDarkTheme
                            ? AppConstants.textColor[800]
                            : AppConstants.textColor[200],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _atSignSection(chatProvider) {
    return Consumer<SearchUserProvider>(
      builder: (_, searchSignProvider, __) {
        return searchSignProvider.atSign == null
            ? const SizedBox()
            : searchSignProvider.loading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    constraints:
                        const BoxConstraints(maxHeight: 350, minHeight: 0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) {
                        User user = searchSignProvider.usersList[index];
                        return ListTile(
                          onTap: () {
                            chatProvider.chatController.text =
                                chatProvider.chatController.text.replaceAll(
                                    searchSignProvider.atSign!,
                                    ' @${user.username} ');

                            searchSignProvider.onDetectionFinished();
                          },
                          title: Text(user.username ?? ''),
                          trailing: Text(user.name ?? 'guest'),
                        );
                      },
                      itemCount: searchSignProvider.usersList.length,
                    ),
                    color: Colors.white,
                  );
      },
    );
  }

  Widget _emojiOffstageSection(
      ChatProvider chatProvider, GlobalSettingProvider globalSetting) {
    return Offstage(
      offstage: !chatProvider.showEmoji,
      child: SizedBox(
        height: 300,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) =>
              chatProvider.onEmojiSelected(emoji),
          onBackspacePressed: chatProvider.onBackspacePressed,
          config: Config(
            columns: 8,
            emojiSizeMax: 32,
            verticalSpacing: 0,
            horizontalSpacing: 0,
            initCategory: Category.RECENT,
            bgColor: globalSetting.isDarkTheme
                ? AppConstants.textColor[900]!
                : AppConstants.textColor[50]!,
            indicatorColor: Colors.blue,
            iconColor: Colors.blueGrey,
            iconColorSelected: Colors.blue,
            backspaceColor: Colors.blue,
            skinToneDialogBgColor: Colors.white,
            skinToneIndicatorColor: Colors.blueGrey,
            enableSkinTones: true,
            showRecentsTab: true,
            recentsLimit: 100,
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL,
          ),
        ),
      ),
    );
  }

  Widget _attachmentOffstageSection(
      ChatProvider chatProvider, GlobalSettingProvider globalSetting, _width) {
    return Offstage(
      offstage: !chatProvider.showShareFile,
      child: MasonryGridView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6.0),
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _width ~/ 260),
        children: [
          if (LoginProvider.platform == 'android' ||
              LoginProvider.platform == 'ios')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                leading: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: const SizedBox(
                      height: 36, width: 36, child: Icon(Icons.camera)),
                ),
                title: const AppText("Camera"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minLeadingWidth: 30,
                onTap: () async {
                  final image = await chatProvider.imagePicker.pickImage(
                      source: ImageSource.camera,
                      maxHeight: 512,
                      imageQuality: 60);
                  if (image != null) {
                    chatProvider.preSendAttachment(image, type: 'photo');
                  }
                },
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                tileColor: globalSetting.isDarkTheme
                    ? AppConstants.textColor[800]
                    : AppConstants.scaffoldLightBackground,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: const SizedBox(
                    height: 36, width: 36, child: Icon(Icons.image_rounded)),
              ),
              title: const AppText("Image"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minLeadingWidth: 30,
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                );

                if (result?.files.isNotEmpty ?? false) {
                  chatProvider.preSendAttachment(result, type: 'photo');
                }
              },
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              tileColor: globalSetting.isDarkTheme
                  ? AppConstants.textColor[800]
                  : AppConstants.scaffoldLightBackground,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: const SizedBox(
                    height: 36,
                    width: 36,
                    child: Icon(Icons.video_camera_back_rounded)),
              ),
              title: const AppText("Video"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minLeadingWidth: 30,
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.video,
                );
                if (result != null) {
                  chatProvider.preSendAttachment(result, type: 'video');
                }
              },
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              tileColor: globalSetting.isDarkTheme
                  ? AppConstants.textColor[800]
                  : AppConstants.scaffoldLightBackground,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: const SizedBox(
                    height: 36,
                    width: 36,
                    child: Icon(Icons.audio_file_rounded)),
              ),
              title: const AppText("Audio"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minLeadingWidth: 30,
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.audio,
                );
                if (result != null) {
                  chatProvider.preSendAttachment(result, type: 'audio');
                }
              },
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              tileColor: globalSetting.isDarkTheme
                  ? AppConstants.textColor[800]
                  : AppConstants.scaffoldLightBackground,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: const SizedBox(
                    height: 36,
                    width: 36,
                    child: Icon(Icons.attachment_rounded)),
              ),
              title: const AppText("Document"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minLeadingWidth: 30,
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.any,
                );
                if (result != null) {
                  chatProvider.preSendAttachment(result, type: 'doc');
                }
              },
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              tileColor: globalSetting.isDarkTheme
                  ? AppConstants.textColor[800]
                  : AppConstants.scaffoldLightBackground,
            ),
          ),
        ],
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget _preSendFilesOffstageSection(ChatProvider chatProvider,
      GlobalSettingProvider globalSetting, double width) {
    return Offstage(
      offstage: !chatProvider.showPreUploadFile,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              width: 100,
              child: Divider(color: Colors.blueGrey, height: 2),
              height: 25,
            ),

            /// text + close icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AppText(
                        'Send ${chatProvider.preUploadFiles.length == 1 ? chatProvider.preUploadFiles.first.type : 'files'}'),
                  ),
                  AppButtonTransparent(
                    child: const Icon(Icons.close),
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    onPressed: chatProvider.clearPreSendAttachment,
                  ),
                ],
              ),
            ),

            /// files display
            Container(
              constraints: const BoxConstraints(
                maxHeight: 200,
              ),
              child: ListView.builder(
                itemCount: chatProvider.preUploadFiles.length,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                controller: ScrollController(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final file = chatProvider.preUploadFiles[index];
                  return Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusCircular),
                    ),
                    child: Builder(
                      builder: (context) {
                        switch (file.type) {
                          case 'photo':
                            return Image.memory(
                              file.fileBytes,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            );
                          case 'doc':
                            return SizedBox(
                              width: 200,
                              height: 200,
                              child: Column(
                                children: [
                                  const Expanded(
                                    child: Center(
                                      child: Icon(
                                        Icons.file_copy_rounded,
                                        size: 28,
                                      ),
                                    ),
                                    flex: 3,
                                  ),
                                  const AppText(
                                    'Document',
                                    fontWeight: FontWeight.bold,
                                    size: 18,
                                    maxLines: 1,
                                  ),
                                  AppText(
                                    file.path,
                                    size: 12,
                                    maxLines: 1,
                                  ),
                                  const Spacer(
                                    flex: 1,
                                  )
                                ],
                              ),
                            );
                          case 'voice':
                            return SizedBox(
                              width: width - 70,
                              height: 200,
                              child: Column(
                                children: [
                                  const Expanded(
                                    child: Center(
                                      child: Icon(
                                        Icons.keyboard_voice_rounded,
                                        size: 28,
                                      ),
                                    ),
                                    flex: 3,
                                  ),
                                  const AppText(
                                    'Voice',
                                    fontWeight: FontWeight.bold,
                                    size: 18,
                                    maxLines: 1,
                                  ),
                                  // AppText(file.path, size: 12, maxLines: 1,),
                                  const Spacer(
                                    flex: 1,
                                  )
                                ],
                              ),
                            );
                        }
                        return const SizedBox(
                            width: 200,
                            child: Center(child: AppText('update Required!')));
                      },
                    ),
                  );
                },
              ),
            ),

            Center(
              child: SizedBox(
                  child: Divider(
                      height: 1,
                      color: globalSetting.isDarkTheme
                          ? AppConstants.textColor[600]
                          : AppConstants.textColor[100])),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _replyOffStateSection(ChatProvider chatProvider) {
  // String displayLastChat = '';
  // if (chatProvider.replyTo != null) {
  //   if (chatProvider.replyTo is ChatTextModel) {
  //     ChatTextModel? chat = chatProvider.replyTo as ChatTextModel;
  //     displayLastChat = chat.text ?? '';
  //   } else if (chatProvider.replyTo is ChatPhotoModel) {
  //     displayLastChat = 'Photo';
  //   } else if (chatProvider.replyTo is ChatDocModel) {
  //     displayLastChat = 'Document';
  //   } else if (chatProvider.replyTo is ChatVoiceModel) {
  //     displayLastChat = 'Voice';
  //   } else if (chatProvider.replyTo is ChatUpdateRequireModel) {
  //     displayLastChat =
  //         'this message is not supported on your version of business chat!';
  //   }
  // }

  return Offstage(
    offstage: chatProvider.replyTo == null,
    child: chatProvider.replyTo != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.reply_all_rounded),
                ),
                Expanded(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            chatProvider.replyTo!.user!.name!,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.blueGrey),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          AppText(
                            Utils.displayChatSubTitle(chatProvider.replyTo!),
                            maxLines: 1,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      chatProvider.clearChatReply();
                    },
                    icon: const Icon(Icons.close_rounded))
              ],
            ),
          )
        : const SizedBox(),
  );
}

Widget _editOffStateSection(ChatProvider chatProvider) {

  return Offstage(
    offstage: chatProvider.editTo == null,
    child: chatProvider.editTo != null
        ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.edit_rounded),
          ),
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text(
                    //   chatProvider.replyTo!.user!.name!,
                    //   maxLines: 1,
                    //   style: const TextStyle(color: Colors.blueGrey),
                    // ),
                    AppText(Utils.displayChatSubTitle(chatProvider.editTo!), maxLines: 1,)
                  ],
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                chatProvider.clearChatEdit();
              },
              icon: const Icon(Icons.close_rounded))
        ],
      ),
    )
        : const SizedBox(),
  );
}
