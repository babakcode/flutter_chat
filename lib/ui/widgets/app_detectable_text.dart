import 'package:flutter/material.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/detectable_text_field.dart' as detectable;
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_constants.dart';

class AppDetectableText extends StatelessWidget {
  final String text;
  final Color? textColor;

  const AppDetectableText(this.text, {Key? key, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        } else if (tappedText.startsWith('http')) {
          debugPrint('DetectableText >>>>>>> http');
          if (!await launchUrl(AppConstants.appLandingWebPageUri)) {
            throw 'Could not launch ${AppConstants.appLandingWebPageUri}';
          }
        }
      },
      detectionRegExp: hashTagAtSignUrlRegExp,
      basicStyle: TextStyle(color: textColor),
    );
  }
}
