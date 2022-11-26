import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';
import '../../widgets/app_text_field.dart';

class EditProfilePage extends StatelessWidget {
  final String title;
  final String hintTextField;
  final String description;

  const EditProfilePage(
      {Key? key,
      required this.title,
      required this.hintTextField,
      this.description = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        title: AppText(title),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          AppTextField(
            //controller: context.read<LoginProvider>().nameTextController,
            hint: hintTextField,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              description,
              style: const TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
