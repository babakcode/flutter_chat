part of './app_text_item.dart';

Widget _itemText(BuildContext context, bool fromMyAccount, int index) {
  final globalSettingProvider = context.read<GlobalSettingProvider>();

  final chatProvider = context.read<ChatProvider>();

  final Room room = chatProvider.selectedRoom!;
  Chat chat = room.chatList[index];
  return InkWell(
    onTap: null,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          fromMyAccount ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SelectableLinkify(
            text: chat.text ?? '',
            // trimLines: 10,
            // moreStyle: const TextStyle(color: Colors.blueGrey),
            // lessStyle: const TextStyle(color: Colors.blueGrey),
            // colorClickableText: Colors.blue,
            // trimMode: detectable.TrimMode.Line,
            // trimCollapsedText: 'more',
            // trimExpandedText: '...less',
            onSelectionChanged: (selection, cause) {
              print('selection, $selection');
              print('cause, $cause');
            },
            onOpen: (link) {
              print(link.text);
            },
            onTap: () {
              print('object');
              // print('tapped00');
              // debugPrint(tappedText);
              // if (tappedText.startsWith('#')) {
              //   debugPrint('DetectableText >>>>>>> #');
              // } else if (tappedText.startsWith('@')) {
              //   debugPrint('DetectableText >>>>>>> @');
              // } else if (tappedText.startsWith('http')) {
              //   debugPrint('DetectableText >>>>>>> http');
              // }
            },
            style: TextStyle(
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
                intl.DateFormat('HH:mm').format(chat.utcDate ?? DateTime.now()),
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
                Icons.check_rounded,
                size: 8,
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

Widget _itemPhoto(BuildContext context, bool fromMyAccount, int index) {
  final globalSettingProvider = context.read<GlobalSettingProvider>();

  final chatProvider = context.read<ChatProvider>();

  final Room room = chatProvider.selectedRoom!;
  Chat chat = room.chatList[index];
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment:
        fromMyAccount ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      Text(
        chat.text ?? '',
        style: TextStyle(
            color: globalSettingProvider.isDarkTheme
                ? fromMyAccount
                    ? AppConstants.textColor[200]
                    : AppConstants.textColor[700]
                : AppConstants.textColor[700]),
      ),
      Text(
        intl.DateFormat('HH:mm').format(chat.utcDate ?? DateTime.now()),
        style: TextStyle(
            fontSize: 12,
            color: globalSettingProvider.isDarkTheme
                ? fromMyAccount
                    ? AppConstants.textColor[200]
                    : AppConstants.textColor[700]
                : AppConstants.textColor[700]),
      )
    ],
  );
}

Widget _itemVoice(BuildContext context, bool fromMyAccount, int index) {
  final globalSettingProvider = context.read<GlobalSettingProvider>();

  final chatProvider = context.read<ChatProvider>();

  final Room room = chatProvider.selectedRoom!;
  Chat chat = room.chatList[index];
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment:
        fromMyAccount ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      Text(
        chat.text ?? '',
        style: TextStyle(
            color: globalSettingProvider.isDarkTheme
                ? fromMyAccount
                    ? AppConstants.textColor[200]
                    : AppConstants.textColor[700]
                : AppConstants.textColor[700]),
      ),
      Text(
        intl.DateFormat('HH:mm').format(chat.utcDate ?? DateTime.now()),
        style: TextStyle(
            fontSize: 12,
            color: globalSettingProvider.isDarkTheme
                ? fromMyAccount
                    ? AppConstants.textColor[200]
                    : AppConstants.textColor[700]
                : AppConstants.textColor[700]),
      )
    ],
  );
}

Widget _itemUpdateRequired(
    BuildContext context, bool fromMyAccount, int index) {
  return const Text('update required');
}
