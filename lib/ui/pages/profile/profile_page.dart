// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '/constants/app_constants.dart';
// import '/controllers/reguest/profile_requests.dart';
// import '../../../services/request_manager.dart';
// import '/controllers/utils/utils.dart';
// import '/providers/profile_provider.dart';
// import '/ui/widgets/app_text_field.dart';
// import '../../../providers/login_provider.dart';
//
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     ProfileProvider profileProvider = Provider.of(context);
//     LoginProvider loginProvider = Provider.of(context, listen: false);
//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         // decoration: BoxDecoration(gradient: AppConstants.backgroundGradient),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 40.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "profile edit account",
//                   ),
//                   //NetworkImage('http://192.168.1.105:3700/${loginProvider.imgUrl}')
//
//                   SizedBox(
//                     width: 150,
//                     height: 150,
//                     child: MaterialButton(
//                       padding: EdgeInsets.zero,
//                       clipBehavior: Clip.antiAliasWithSaveLayer,
//                       color: Colors.grey.shade400,
//                       shape: const CircleBorder(),
//                       child: loginProvider.modelUser?.imgUrl != null
//                           ? CachedNetworkImage(
//                           errorWidget: (context, error, stackTrace) {
//                             return const Center();
//                           },
//                         imageUrl:
//                               '${RequestManager.baseUrl}/${loginProvider.modelUser?.imgUrl}')
//                           : Image.asset('assets/images/user.png'),
//                       onPressed: () async {
//                         var image = await ImagePicker.platform
//                             .getImage(source: ImageSource.gallery , maxHeight: 512);
//                         if (image != null) {
//                           profileProvider.checkUploadImage(
//                               context, File(image.path));
//                         }
//                       },
//                     ),
//                   ),
//                   AppTextField(
//                       hint: "username",
//                       controller: profileProvider.usernameController),
//                   AppTextField(
//                       hint: "full name",
//                       controller: profileProvider.fullNameController),
//                   AppTextField(
//                       hint: "mobile number",
//                       controller: profileProvider.mobileController,
//                       checkNumberLength: true,
//                       typeKeyboard: true),
//                   AppTextField(
//                       hint: "expert",
//                       controller: profileProvider.expertController),
//                   AppTextField(
//                       hint: "medical council number",
//                       controller: profileProvider.medicalCouncilNumberController),
//                   Card(
//                     clipBehavior: Clip.antiAliasWithSaveLayer,
//                     color: Colors.white,
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(22)),
//                     child: InkWell(
//                       onTap: () async {
//                         var image = await ImagePicker.platform
//                             .getImage(source: ImageSource.gallery , maxHeight: 512);
//                         if (image != null) {
//                           profileProvider.checkUploadSignatureImage(
//                               context, File(image.path));
//                         }
//                       },
//                       child: SizedBox(
//                         width: double.infinity,
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               const Text('عکس امضا'),
//                               Center(
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: loginProvider.modelUser?.signatureImage == null
//                                       ? Opacity(
//                                           opacity: .7,
//                                           child: Image.asset(
//                                             'assets/images/signature.jpg',
//                                             height: 200,
//                                             width: double.infinity,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         )
//                                       : CachedNetworkImage(
//                                     errorWidget: (context, error, stackTrace) {
//                                       return const Center();
//                                     },
//                                     imageUrl:
//                                           '${RequestManager.baseUrl}/${loginProvider.modelUser?.signatureImage}',
//                                           height: 200,
//                                           width: double.infinity,
//                                           fit: BoxFit.cover,
//                                         ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   MaterialButton(
//                     onPressed: () {
//                       if (profileProvider.usernameController?.text == '') {
//                         Utils.showSnack(context, 'یوزرنیم شما خالیست!');
//                         return;
//                       }
//                       ProfileRequests.profile(context).then((value) {
//                         if (value != false) {
//                           print(value.username);
//                           context.read<LoginProvider>().setDataForShared(value);
//                           Navigator.pop(context);
//                         }
//                       });
//                     },
//                     height: 65,
//                     padding: const EdgeInsets.symmetric(horizontal: 32),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24)),
//                     child: const Text("Update"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:chat_babakcode/providers/auth_provider.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../widgets/app_text.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.read<Auth>();
    final globalSettingProvider = context.read<GlobalSettingProvider>();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: MediaQuery.of(context).size.height * .44,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  print(constraints.biggest.height);
                  return FlexibleSpaceBar(
                    title: constraints.biggest.height == 56
                        ? const AppText('Profile')
                        : const SizedBox(),
                    background: Image.asset("assets/images/p1.jpg",
                        width: double.infinity, fit: BoxFit.cover),
                  );
                },
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: ListTile(
                  subtitle: const Text(
                    'name',
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
                        child: Icon(Icons.person_2_rounded)),
                  ),
                  title: AppText(auth.myUser?.name ?? 'Guest'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minLeadingWidth: 30,
                  onTap: () {},
                  trailing: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: const SizedBox(
                        height: 36,
                        width: 36,
                        child: Icon(Icons.add_a_photo_rounded)),
                  ),
                  tileColor: globalSettingProvider.isDarkTheme
                      ? AppConstants.textColor[900]
                      : AppConstants.scaffoldLightBackground,
                ),
              ),
              Container(
                height: 4000,
                color: Colors.red,
                width: double.infinity,
              )
            ],
          ),
        ),
      ),
    );
  }
}
