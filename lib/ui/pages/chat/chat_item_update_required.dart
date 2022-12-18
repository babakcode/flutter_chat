import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/widgets/app_detectable_text.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';

class ChatItemUpdateRequired extends StatelessWidget {
  final bool fromMyAccount;

  const ChatItemUpdateRequired(this.fromMyAccount, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalSetting = context.watch<GlobalSettingProvider>();
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: AppDetectableText(
          'This message is not supported on your version of business chat!\nPlease checkout the @app channel to see and update the app to newer version.',
          textColor: globalSetting.isDarkTheme
              ? fromMyAccount
                  ? AppConstants.textColor[200]
                  : AppConstants.textColor[700]
              : AppConstants.textColor[700],
        ));
  }
}
