import 'package:chat_babakcode/constants/app_constants.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppButtonTransparent extends StatelessWidget {

  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const AppButtonTransparent({Key? key,
    required this.child,
    this.onPressed,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final sharedProvider = context.watch<GlobalSettingProvider>();

    return Padding(
      padding: margin ?? const EdgeInsets.all(8.0),
      child: MaterialButton(onPressed: onPressed ?? (){},
        height: 56,
        minWidth: 40,
        splashColor: AppConstants.primarySwatch[400]!.withOpacity(.9),
        highlightColor: AppConstants.primarySwatch[50]!.withOpacity(.3),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
        textTheme: sharedProvider.isDarkTheme ? ButtonTextTheme.primary: ButtonTextTheme.accent ,
        shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: child,
      ),
    );
  }
}
