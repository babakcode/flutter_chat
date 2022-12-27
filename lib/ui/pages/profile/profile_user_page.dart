import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_babakcode/main.dart';
import 'package:chat_babakcode/models/chat.dart';
import 'package:chat_babakcode/models/room.dart';
import 'package:chat_babakcode/models/user.dart';
import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/chat_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/providers/profile_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_page.dart';
import 'package:chat_babakcode/ui/pages/profile/edit_profile_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../../utils/utils.dart';
import '../../widgets/app_text.dart';

class ProfileUserPage extends StatefulWidget {
  final User user;

  const ProfileUserPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  late User user;
  bool isMyUser = false;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<Auth>();
    if (user.publicToken == auth.myUser?.publicToken) {
      isMyUser = true;
      user = auth.myUser!;
    }
    final globalSettingProvider = context.read<GlobalSettingProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final chatProvider = context.read<ChatProvider>();

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
                  expandedHeight: MediaQuery.of(context).size.height * .3,
                  flexibleSpace: FlexibleSpaceBar(
                    title: AnimatedOpacity(
                        opacity: constraints.scrollOffset > 0 ? 1 : 0,
                        duration: const Duration(milliseconds: 600),
                        child: const AppText('Profile')),
                    background: user.profileUrl == null
                        ? Image.asset("assets/images/p2.jpg",
                            width: double.infinity, fit: BoxFit.cover)
                        : CachedNetworkImage(
                        imageUrl: user.profileUrl!,
                            width: double.infinity, fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ];
        },
        body: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    title: AppText(user.name ?? 'Guest'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minLeadingWidth: 30,
                    onTap: () {
                      if (isMyUser) {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => EditProfilePage(
                                title: 'name',
                                hintTextField:
                                    user.name ?? 'please enter your name',
                                description:
                                    'You can enter a username in Business Chat. People can see you by this name',
                              ),
                            ));
                        return;
                      }
                    },
                    trailing: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: SizedBox(
                          height: 36,
                          width: 36,
                          child: InkWell(
                            child: isMyUser
                                ? const Icon(Icons.add_a_photo_rounded)
                                : const Icon(Icons.chat_outlined),
                            onTap: () async {
                              if (isMyUser) {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                );

                                if (result?.files.isNotEmpty ?? false) {

                                  for (PlatformFile file in result!.files) {
                                    // var item = File(file.path!);
                                    profileProvider.updateProfileImage(file);
                                  }
                                }
                                return;
                              }
                              chatProvider.searchRoom(
                                  // searchType: 'token',
                                  searchText: user.publicToken!,
                                  context: context,
                              callBack: (data) async {

                                if(data['success']){


                                  final room = data['room'];
                                  if(chatProvider.selectedRoom == room){
                                    Navigator.pop(context);
                                  }else{

                                    if (GlobalSettingProvider.isPhonePortraitSize) {
                                      Navigator.pop(context);
                                    } else {
                                      final n = Navigator.of(context);
                                      n.pop();
                                      n.pop();
                                    }
                                    chatProvider.changeSelectedRoom(room);

                                  }
                                  // Navigator.pop(context);
                                  // int count = 0;
                                  // Navigator.of(context).popUntil((_) => count++ >= 2);
                                  //
                                  // chatProvider.selectedRoom = room;
                                  //
                                  // await Future.delayed(const Duration(milliseconds: 100));

                                  // if(data['findFromExistRoom']){
                                  //
                                  //   /// room found
                                  //
                                  //   if (GlobalSettingProvider.isPhonePortraitSize) {
                                  //     Navigator.push(
                                  //         context,
                                  //         CupertinoPageRoute(
                                  //           builder: (context) => const ChatPage(),
                                  //         ));
                                  //   } else {
                                  //     notifyListeners();
                                  //   }
                                  // }else{
                                  //
                                  //   selectedRoom = Room.fromJson(data['room'], false);
                                  //
                                  //   if (GlobalSettingProvider.isPhonePortraitSize) {
                                  //     Navigator.push(
                                  //       navigatorKey.currentContext!,
                                  //       CupertinoPageRoute(
                                  //         builder: (context) => const ChatPage(),
                                  //       ),
                                  //     );
                                  //   } else {
                                  //     notifyListeners();
                                  //   }
                                  // }

                                }else{
                                  Utils.showSnack( data['msg']);
                                }
                              });

                              // /// todo create fake chat page
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => const ChatPage(),
                              //     ));
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
                  user.username != null || isMyUser
                      ? ListTile(
                          subtitle: const Text(
                            'Username',
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          leading: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: const SizedBox(
                                height: 36, width: 36, child: Icon(Icons.abc)),
                          ),
                          title: AppText(user.username ?? 'None'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minLeadingWidth: 30,
                          onTap: () {
                            if (isMyUser) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => EditProfilePage(
                                      title: 'username',
                                      hintTextField: user.username ?? 'username',
                                      description:
                                          'You can choose a username on Business chat. If you do, people will be able to find you by this username and contact you without needing your phone number.\n\nYou can use a-z, 0-9 and underscores. Minimum length is 5 characters.',
                                    ),
                                  ));
                              return;
                            }
                            Utils.copyText(user.username ?? '');
                          },
                          tileColor: globalSettingProvider.isDarkTheme
                              ? AppConstants.textColor[900]
                              : AppConstants.scaffoldLightBackground,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
