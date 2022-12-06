import 'package:chat_babakcode/constants/app_constants.dart';
import 'package:chat_babakcode/providers/login_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/pages/login/login_display_name_page.dart';
import 'package:chat_babakcode/ui/widgets/app_button_transparent.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../widgets/app_button.dart';
import '../../widgets/app_button_rounded.dart';

class LoginGenerateTokenPage extends StatefulWidget {
  const LoginGenerateTokenPage({super.key});

  @override
  State<LoginGenerateTokenPage> createState() => _LoginGenerateTokenPageState();
}

class _LoginGenerateTokenPageState extends State<LoginGenerateTokenPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => context.read<LoginProvider>().generateSha256Token());
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.read<LoginProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    AppButtonTransparent(
                        onPressed: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios_new_rounded)),
                    Center(
                      child: SvgPicture.asset(
                        'assets/svg/logo.svg',
                        height: 60,
                        color: const Color(0xFF10b2f6),
                        width: 60,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .04,
                ),
                Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Image.asset(
                      'assets/images/p3.jpg',
                      height: 240,
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .10,
                ),
                AppText(
                  'Your public token',
                  color: context.read<GlobalSettingProvider>().isDarkTheme
                      ? AppConstants.textColor.shade50
                      : AppConstants.textColor,
                  fontWeight: FontWeight.w900,
                  size: 18,
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 330,
                  child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: AppConstants.primarySwatch[50]!, width: 2),
                      ),
                      borderOnForeground: true,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Consumer<LoginProvider>(
                          builder: (_, loginProvider, child) => AppText(
                            loginProvider.randomDigits,
                            size: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  width: 330,
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          onPressed: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      const LoginDisplayNameProvider())),
                          child: Row(
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
                      Consumer<LoginProvider>(builder: (_, provider, child) {
                        return AppButtonRounded(
                            margin: const EdgeInsets.only(top: 10, left: 5),
                            child: AnimatedSwitcher(
                              duration: const Duration(seconds: 1),
                              child: Icon(provider.copied
                                  ? Icons.check_rounded
                                  : Icons.copy_rounded),
                            ),
                            onPressed: loginProvider.copyToken);
                      }),
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
