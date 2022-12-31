import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/detectable_text_field.dart' as detectable;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_constants.dart';

class AppDetectableText extends StatelessWidget {
  final String text;
  final Color? textColor;

  const AppDetectableText(this.text, {Key? key, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    final chatProvider = context.read<ChatProvider>();
    return detectable.DetectableText(
      text: text,
      trimLines: 10,
      moreStyle: const TextStyle(color: Colors.blueGrey),
      lessStyle: const TextStyle(color: Colors.blueGrey),
      colorClickableText: Colors.blue,
      trimMode: detectable.TrimMode.Line,
      trimCollapsedText: 'more',
      trimExpandedText: '...less',
      onTap: (tappedText) async {
        debugPrint(tappedText);
        if (tappedText.startsWith('#')) {
          debugPrint('DetectableText >>>>>>> #');
        } else if (tappedText.startsWith('@')) {
          debugPrint('DetectableText >>>>>>> @');
          chatProvider.searchRoom(
              searchText: tappedText.replaceAll('@', ''),
              context: context,
              callBack: (data) {
                if(data['success']){
                  if(data['findFromExistRoom']){
                    chatProvider.changeSelectedRoom(data['room']);
                  }
                }
              });
        } else if (tappedText.startsWith('http')) {
          debugPrint('DetectableText >>>>>>> http');
          if (!await launchUrl(Uri.parse(tappedText))) {
            throw 'Could not launch $tappedText';
          }
        }
      },
      detectionRegExp: hashTagAtSignUrlRegExp,
      basicStyle: TextStyle(color: textColor),
    );
  }
}
