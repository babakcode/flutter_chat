import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../providers/global_setting_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';

class CreateChannelPage extends StatelessWidget {
  const CreateChannelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final setting = context.read<GlobalSettingProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        title: const Text("Create Channel"),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

              ],
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: AppText('You can find the user in the following ways.',
                  size: 14),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
            //   child: AppText(
            //       'paste the user `${searchUserProvider.searchWayList[searchUserProvider.selectedSearchUserWayIndex]}` in following section',
            //       size: 14),
            // ),
            // AppTextField(
            //   hint: searchUserProvider
            //       .searchWayList[searchUserProvider.selectedSearchUserWayIndex],
            //   controller: searchUserProvider.userSearchTextEditController,
            // ),
            // AppButton(
            //   onPressed: () => searchUserProvider.searchUser(context),
            //   child: const Text('search'),
            //   margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            // )
          ],
        ),
      ),
    );
  }
}
