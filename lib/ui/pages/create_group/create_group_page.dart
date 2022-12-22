import 'dart:io';
import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_constants.dart';
import '../../../providers/group_provider.dart';

class CreateGroupPage extends StatelessWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groupProvider = context.watch<GroupProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        actions: [
          IconButton(
            onPressed: groupProvider.createGroup,
            icon: const Icon(Icons.check_rounded),
          ),
        ],
        title: const Text("Create group"),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
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
                          onPressed: groupProvider.selectImage,
                          child: groupProvider.groupImage == null
                              ? const Icon(Icons.add_a_photo_rounded)
                              : Image.memory(
                                  kIsWeb
                                      ? groupProvider.groupImage!.bytes!
                                      : File(groupProvider.groupImage!.path!)
                                          .readAsBytesSync(),
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          controller: groupProvider.groupNameController,
                          decoration: const InputDecoration(hintText: 'Group name'),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   TextField(
                    controller: groupProvider.groupDescriptionController,
                    decoration: const InputDecoration(hintText: 'Description'),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  const Text(
                    'You can provide an optional description for your group.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RadioListTile(
                    title: const Text('Public Group'),
                    subtitle: const Text(
                      'Public groups can be found in search, anyone can join them',
                      style: TextStyle(fontSize: 12),
                    ),
                    value: false,
                    groupValue: groupProvider.getIsPrivate,
                    onChanged: (p0) {
                      groupProvider.setIsPrivate = p0!;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RadioListTile(
                    title: const Text('Private Group'),
                    subtitle: const Text(
                        'Private Groups can only be joined via invite link',
                        style: TextStyle(fontSize: 12)),
                    value: true,
                    groupValue: groupProvider.getIsPrivate,
                    onChanged: (p0) {
                      groupProvider.setIsPrivate = p0!;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  groupProvider.getIsPrivate
                      ? AppText(groupProvider.privateLink)
                      : TextField(
                          controller: groupProvider.groupLinkController,
                          decoration: const InputDecoration(
                              hintText: 'Username', prefixText: '@'),
                        ),
                  const SizedBox(
                    height: 14,
                  ),
                  const Text(
                    'You set a public link, other people will be able to find\nand join your group.\n\nYou can use a-z, 0-9 and underscores\nMinimum length is 5 characters',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 14,
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
