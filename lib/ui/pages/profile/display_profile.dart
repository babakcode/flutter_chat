import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_babakcode/models/user.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_constants.dart';

class DisplayProfilePage extends StatelessWidget {
  final User user;
  final String tag;

  const DisplayProfilePage({Key? key, required this.user, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Hero(
                tag: tag,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Card(
                    margin: const EdgeInsets.all(5),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: const CircleBorder(),
                    child: user.profileUrl != null
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            errorWidget: (context, error, stackTrace) {
                              return const Center();
                            },
                            imageUrl:
                                '${AppConstants.baseUrl}/${user.profileUrl}')
                        : const Icon(Icons.person),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('@' + (user.username ?? '')),
              subtitle: const Text('id'),
            ),
            ListTile(
              title: Text(user.name ?? 'empty'),
              subtitle: const Text('full name'),
            ),
          ],
        ),
      ),
    );
  }
}
