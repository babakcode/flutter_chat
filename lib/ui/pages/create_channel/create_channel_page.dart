import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../providers/channel_provider.dart';
import '../../../providers/global_setting_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';

class CreateChannelPage extends StatelessWidget {
  const CreateChannelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channelProvider = context.watch<ChannelProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.check_rounded),
          ),
        ],
        title: const Text("Create Channel"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth:500),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      MaterialButton(
                          color: AppConstants.blueAccent,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: EdgeInsets.zero,
                          minWidth: 60,
                          height: 60,
                          onPressed: channelProvider.selectImage,
                          child: channelProvider.channelImage == null ?const Icon(Icons.add_a_photo_rounded)
                          : Image.memory(kIsWeb ? channelProvider.channelImage!.bytes! : File(channelProvider.channelImage!.path!).readAsBytesSync(),
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,)
                          ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(hintText: 'Channel name'),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const TextField(
                    decoration: InputDecoration(hintText: 'Description'),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  const Text(
                    'You can provide an optional description for your\nchannel.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const TextField(
                    decoration: InputDecoration(hintText: 'Username',prefixText: '@'),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  const Text(
                    'You set a public link, other people will be able to find\nand join your channel.\n\nYou can use a-z, 0-9 and underscores\nMinimum length is 5 characters',
                    style: TextStyle(color: Colors.grey),
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
          ),
        ),
      ),
    );
  }
}
