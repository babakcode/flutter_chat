import 'package:chat_babakcode/ui/widgets/app_text.dart';
import 'package:chat_babakcode/ui/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class PreSendFilePage extends StatelessWidget {
  const PreSendFilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText('Send File'),
      ),
      body: Column(
        children: [
          Expanded(child: Container()),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  margin: EdgeInsets.all(16),
                  hint: 'text',
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}
