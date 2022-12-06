import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';

class ChatItemUpdateRequired extends StatelessWidget {
  final bool fromMyAccount;
  const ChatItemUpdateRequired(this.fromMyAccount,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final globalSetting = context.watch<GlobalSettingProvider>();
    return
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: DetectableText(
          text: 'this message is not supported on your version of business chat!\nPlease checkout the @app channel to see and update the app to newer version.',
          trimLines: 10,
          moreStyle: const TextStyle(color: Colors.blueGrey),
          lessStyle: const TextStyle(color: Colors.blueGrey),
          colorClickableText: Colors.blue,
          trimMode: TrimMode.Line,
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
      );
  }
}
