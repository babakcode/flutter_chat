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
                        child: Icon(Icons.person_rounded)),
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
