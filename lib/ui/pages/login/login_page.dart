import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/pages/login/login_generate_token.dart';
import 'package:chat_babakcode/ui/pages/login/login_recovery.dart';
import 'package:chat_babakcode/ui/widgets/app_button.dart';
import 'package:chat_babakcode/ui/widgets/app_button_rounded.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/logo.svg',
                  height: 60,
                  color: const Color(0xFF10b2f6),
                  width: 60,
                ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .12,
                  ),
                Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Image.asset(
                      'assets/images/p2.jpg',
                      height: 240,
                    )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .10,
                  ),
                SizedBox(
                  width: 300,
                  child: AppButton(
                    onPressed: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      const LoginGenerateTokenPage(),),),
                          
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.app_registration_rounded),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Create Biz account'),
                      ],
                    ),
                    margin: EdgeInsets.zero,
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButtonRounded(
                          onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => const LoginRecovery())),child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.person_rounded),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Continue your account'),
                            ],
                          ),
                          margin: const EdgeInsets.only(top: 10, right: 5),
                        ),
                      ),
                      AppButtonRounded(
                        margin: const EdgeInsets.only(top: 10, left: 5),
                        child: Icon(context.watch<GlobalSettingProvider>().isDarkTheme
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded),
                        onPressed: () => context.read<GlobalSettingProvider>().darkTheme(
                            !context.read<GlobalSettingProvider>().isDarkTheme),
                      ),
                    ],
                  ),
                ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
