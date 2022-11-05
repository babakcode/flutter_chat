import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../providers/login_provider.dart';
import '../../../providers/global_setting_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_button_transparent.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';

class LoginRecovery extends StatelessWidget {
  const LoginRecovery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
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
                  // Spacer()
                  
                SizedBox(
                  height: MediaQuery.of(context).size.height * .07,
                ),
                  Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.asset(
                        'assets/images/p1.jpg',
                        height: 240,
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .10,
                  ),

                  AppText(
                    'Recovery phrase',
                    color: context.read<GlobalSettingProvider>().isDarkTheme
                        ? AppConstants.textColor.shade50
                        : AppConstants.textColor,
                    fontWeight: FontWeight.w900,
                    size: 18,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(
                    width: 310,
                    child: AppText('enter your recovery phrase whitout space that was given to you when you signed up to restore your account.',
                      size: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 310,
                    child: AppTextField(
                      controller: context
                          .read<LoginProvider>()
                          .recoveryPhraseTextController,
                      hint: 'Enter recovery phrase',
                      margin: EdgeInsets.zero,
                    ),
                  ),
                  AppButton(
                    onPressed: context.read<LoginProvider>().recoveryToken,
                    child:
                        Consumer<LoginProvider>(builder: (_, provider, child) {
                      return AnimatedSize(
                        duration: const Duration(milliseconds: 100),
                        child: provider.loading
                            ? const CircularProgressIndicator()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.person_rounded),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Continue your account'),
                                ],
                              ),
                      );
                    }),
                    margin: const EdgeInsets.only(top: 10, right: 5),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
