
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


class _ItemPhoto extends StatelessWidget {
  final bool fromMyAccount;
  final int index;
  const _ItemPhoto(this.fromMyAccount, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalSettingProvider = context.read<GlobalSettingProvider>();

    final chatProvider = context.read<ChatProvider>();

    final Room room = chatProvider.selectedRoom!;
    Chat chat = room.chatList[index];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
      fromMyAccount ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Image.network(chat.fileUrl!,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: InkWell(
                      onTap: () => chatProvider.refreshPage(room),
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
