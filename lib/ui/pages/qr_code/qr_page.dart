import 'package:chat_babakcode/constants/app_constants.dart';
import 'package:chat_babakcode/generated/assets.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';


class QrPage extends StatelessWidget {

  final String token;
  const QrPage({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText('qr code'),
      ),
      body: SafeArea(
        child: Center(
          child: QrImage(
            data: token,
            version: QrVersions.auto,
            dataModuleStyle: QrDataModuleStyle(color: AppConstants.blueAccent, dataModuleShape: QrDataModuleShape.circle,),
            embeddedImageStyle: QrEmbeddedImageStyle(color: context.read<GlobalSettingProvider>().isDarkTheme ? AppConstants.scaffoldLightBackground : AppConstants.scaffoldDarkBackground),
            gapless: true,
            constrainErrorBounds: true,
            embeddedImageEmitsError: true,
            semanticsLabel: 'hi ',
            eyeStyle: const QrEyeStyle(color: Colors.blue, eyeShape: QrEyeShape.square),
            embeddedImage: const AssetImage(Assets.imagesLogo),
            size: 280.0,
          ),
        ),
      ),
    );
  }
}
