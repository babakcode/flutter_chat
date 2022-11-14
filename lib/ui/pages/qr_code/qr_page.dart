import 'package:chat_babakcode/constants/app_constants.dart';
import 'package:chat_babakcode/constants/config.dart';
import 'package:chat_babakcode/generated/assets.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/widgets/app_button.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../models/user.dart';


class QrPage extends StatelessWidget {

  final User user;
  const QrPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),),
        title: const AppText('qr code'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60,),
                Card(
                  elevation: 0,
                  color: AppConstants.textColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConfig.radiusCircular)
                  ),
                  child: QrImage(
                    data: user.publicToken!,
                    padding: const EdgeInsets.all(20),
                    version: QrVersions.auto,
                    dataModuleStyle: QrDataModuleStyle(color: AppConstants.blueAccent, dataModuleShape: QrDataModuleShape.circle,),
                    gapless: true,
                    constrainErrorBounds: true,
                    embeddedImageEmitsError: true,
                    eyeStyle: const QrEyeStyle(color: Colors.blue, eyeShape: QrEyeShape.circle),
                    embeddedImageStyle: QrEmbeddedImageStyle(color: AppConstants.scaffoldLightBackground),
                    embeddedImage: const AssetImage(Assets.imagesLogo),
                    size: 280.0,
                  ),
                ),
                const SizedBox(height: 30,),

                AppText(user.name!, size: 26,),

                const Text('Give this QR code to a friend who wanna text you.', textAlign: TextAlign.center),

                // AppButton(child: Text("share"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
