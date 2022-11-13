import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/pages/qr_code/qr_page.dart';
import 'package:chat_babakcode/ui/widgets/app_button_transparent.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:chat_babakcode/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';

class HomeSettingComponent extends StatelessWidget {
  const HomeSettingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final globalSetting = context.watch<GlobalSettingProvider>();
    final auth = context.read<Auth>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const AppText('Setting'),
                    const Spacer(),
                    AppButtonTransparent(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: const Icon(Icons.qr_code_2_rounded),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(user: auth.myUser!))),
                    ),
                    AppButtonTransparent(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Icon(globalSetting.isDarkTheme
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded),
                      onPressed: globalSetting.toggleThemeMode,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/p1.jpg',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                    elevation: 0,
                    color: globalSetting.isDarkTheme? AppConstants.primarySwatch[700]!.withOpacity(.5) : AppConstants.textColor[200]!.withOpacity(.5),
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: AppText(
                        auth.myUser?.publicToken ??
                            '',
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => QrPage(user: auth.myUser!))),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  title: const AppText('my QR code'),
                  leading: const Icon(Icons.qr_code_2_rounded),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  onTap: () => Utils.coptText(auth.myUser?.publicToken ?? ''),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  title: const AppText('copy token'),
                  leading: const Icon(Icons.copy_all_rounded),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  onTap: () {
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  title: const Text('security'),
                  leading: const Icon(Icons.security_rounded),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  onTap: () => auth.logOut(),
                  tileColor: globalSetting.isDarkTheme? AppConstants.primarySwatch[700]!.withOpacity(.5) : AppConstants.textColor[200]!.withOpacity(.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  title: const AppText('Log out'),
                  leading: const Icon(Icons.logout_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
