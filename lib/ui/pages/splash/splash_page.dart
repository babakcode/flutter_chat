import 'dart:io';

import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/login_provider.dart';
import 'package:chat_babakcode/ui/pages/login/login_page.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/global_setting_provider.dart';
import '../home/home_page.dart';
import '/constants/app_constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final sharedProvider = context.read<GlobalSettingProvider>();
      if(sharedProvider.settingBox.get('dark') == null){
        sharedProvider.darkTheme( MediaQuery.of(context).platformBrightness == Brightness.dark);
      }
    });

    try {
      LoginProvider.platform = Platform.isAndroid
          ? 'android'
          : Platform.isIOS
          ? 'ios'
          : Platform.isWindows
          ? 'windows'
          : 'web';
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      LoginProvider.platform = 'web';
    }
    if(context.read<Auth>().loggedIn){

      Future.delayed(
          const Duration(seconds: 2),
              () =>
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => const HomePage(),
                ),
                    (route) => false,
              )
      );
      // Navigator.
    }
    else{
      Future.delayed(const Duration(seconds: 6),() => Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const LoginPage(),
        ),
            (route) => false,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    /// hide bottom navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

    final globalSetting = context.watch<GlobalSettingProvider>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
                SizedBox(
                  height: MediaQuery.of(context).size.height * .20,
                ),
              SvgPicture.asset(
                'assets/svg/logo.svg',
                height: 280,
                color: const Color(0xFF10b2f6),
                width: 280,
              ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                ),
              AppText(
                "Business Chat",
                size: 32,
                color: globalSetting.isDarkTheme
                    ? AppConstants.textColor.shade50
                    : AppConstants.textColor,
                fontWeight: FontWeight.w900,
              ),
              const SizedBox(
                height: 12,
              ),
              const AppText(
                "Be your Boss",
                size: 14,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                child: LinearProgressIndicator(
                  backgroundColor: AppConstants.blueAccent,
                ),
                width: 60,
              ),
              
                SizedBox(
                  height: MediaQuery.of(context).size.height * .20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
