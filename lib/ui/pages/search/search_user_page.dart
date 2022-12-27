import 'package:chat_babakcode/constants/app_constants.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/providers/search_user_provider.dart';
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
    final searchUserProvider = context.watch<SearchUserProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
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
                    searchUserProvider.searchWayList.length,
                    (index) => Card(
                      elevation: 0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      color:
                          searchUserProvider.selectedSearchUserWayIndex == index
                              ? null
                              : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: InkWell(
                        onTap: () => searchUserProvider
                            .setIndexSelectedSearchUserWay = index,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Text(searchUserProvider.searchWayList[index]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
              child: AppText(
                  'paste the user `${searchUserProvider.searchWayList[searchUserProvider.selectedSearchUserWayIndex]}` in following section',
                  size: 14),
            ),
            AppTextField(
              hint: searchUserProvider
                  .searchWayList[searchUserProvider.selectedSearchUserWayIndex],
              controller: searchUserProvider.userSearchTextEditController,
            ),
            AppButton(
              onPressed: () => searchUserProvider.search(context),
              child: const Text('search'),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            )
          ],
        ),
      ),
    );
  }
}
