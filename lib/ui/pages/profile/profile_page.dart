import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/providers/profile_provider.dart';
import 'package:chat_babakcode/ui/pages/profile/edit_profile_page.dart';
import 'package:chat_babakcode/ui/widgets/app_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../widgets/app_text.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<Auth>();
    final globalSettingProvider = context.read<GlobalSettingProvider>();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverLayoutBuilder(
              builder: (BuildContext context, constraints) {
                return SliverAppBar(
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                  ),
                  pinned: true,
                  floating: false,
                  expandedHeight: MediaQuery.of(context).size.height * .44,
                  flexibleSpace: FlexibleSpaceBar(
                    title: constraints.scrollOffset > 0
                        ? const AppText('Profile')
                        : const SizedBox(),
                    background: Image.asset("assets/images/p1.jpg",
                        width: double.infinity, fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              children: [
                ListTile(
                  subtitle: const Text(
                    'Name',
                    style: TextStyle(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const SizedBox(
                        height: 36,
                        width: 36,
                        child: Icon(Icons.person_rounded)),
                  ),
                  title: AppText(auth.myUser?.name ?? 'Guest'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minLeadingWidth: 30,
                  onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EditProfilePage(
                          title: 'name',
                          hintTextField:
                              auth.myUser?.name ?? 'please enter your name',
                          description:
                              'You can enter a username in Business Chat. People can see you by this name',
                        ),
                      )),
                  trailing: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: SizedBox(
                        height: 36,
                        width: 36,
                        child: InkWell(
                          child: const Icon(Icons.add_a_photo_rounded),
                          onTap: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.image,
                            );
                            if (result != null) {
                              print(result);
                            }
                          },
                        )),
                  ),
                  tileColor: globalSettingProvider.isDarkTheme
                      ? AppConstants.textColor[900]
                      : AppConstants.scaffoldLightBackground,
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  subtitle: const Text(
                    'Username',
                    style: TextStyle(color: Colors.grey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const SizedBox(
                        height: 36, width: 36, child: Icon(Icons.abc)),
                  ),
                  title: AppText(auth.myUser?.username ?? 'None'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minLeadingWidth: 30,
                  onTap: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EditProfilePage(
                          title: 'username',
                          hintTextField: auth.myUser?.username ?? 'username',
                          description:
                              'You can choose a username on Business chat. If you do, people will be able to find you by this username and contact you without needing your phone number.\n\nYou can use a-z, 0-9 and underscores. Minimum length is 5 characters.',
                        ),
                      )),
                  tileColor: globalSettingProvider.isDarkTheme
                      ? AppConstants.textColor[900]
                      : AppConstants.scaffoldLightBackground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
