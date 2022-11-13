import 'package:chat_babakcode/constants/app_constants.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/widgets/app_button.dart';
import 'package:chat_babakcode/ui/widgets/app_button_transparent.dart';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:chat_babakcode/ui/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchUserPage extends StatelessWidget {
  const SearchUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final setting = context.read<GlobalSettingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Message"),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child:
                  AppText('Search user', size: 20, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: AppText('You can find the user in the following ways.',
                  size: 14),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                    color: setting.isDarkTheme
                        ? AppConstants.textColor[900]
                        : AppConstants.textColor[50],
                    borderRadius: BorderRadius.circular(32)),
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: List.generate(
                    10,
                    (index) => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text('token'),
                      ),
                    ),
                  ),
                ),
              ),
            ),


            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: AppText('You can find the user in the following ways.',
                  size: 14),
            ),


            const AppTextField(hint: 'token',),


            const AppButton(child: Text('search'),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            )
          ],
        ),
      ),
    );
  }
}
