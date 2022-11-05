import 'package:chat_babakcode/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// format codes shortcut : Ctrl + Alt + L
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final EdgeInsetsGeometry? margin;
  final int? minLines, maxLines;
  final Color? backgroundColor;
  final bool checkNumberLength;
  final bool typeKeyboard;
  final double radius;

  const AppTextField(
      {Key? key,
      this.controller,
      this.hint,
      this.margin,
      this.minLines,
      this.maxLines,
      this.backgroundColor,
      this.checkNumberLength = false,
      this.radius = 20,
      this.typeKeyboard = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      elevation: 0,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: TextField(
        keyboardType: typeKeyboard ? TextInputType.number : null,
        inputFormatters: [
          if(checkNumberLength) LengthLimitingTextInputFormatter(11),
        ],
        // style: const TextStyle(fontSize: 18.0, color: Colors.black),
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(radius)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppConstants.primarySwatch[50]!,width: 2),
            borderRadius: BorderRadius.circular(radius)
          ),
            contentPadding: const EdgeInsets.all(22),
            hintText: hint,
            border: InputBorder.none),
        controller: controller,
      ),
    );
  }
}
