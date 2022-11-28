import 'package:chat_babakcode/constants/app_constants.dart';
import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? splashColor;
  final double? elevation;


  const AppButton({Key? key, required this.child, this.onPressed, this.margin , this.color , this.elevation , this.splashColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sharedProvider = context.watch<GlobalSettingProvider>();

    return Padding(
      padding: margin ?? const EdgeInsets.all(8.0),
      child: MaterialButton(
        elevation: elevation,
        onPressed: onPressed ?? (){},
        height: 56,
        splashColor: splashColor ?? AppConstants.primarySwatch[500]!.withOpacity(.9),
        highlightColor: AppConstants.primarySwatch[200]!.withOpacity(.1),
        padding: const EdgeInsets.symmetric(horizontal: 26),
        textTheme: sharedProvider.isDarkTheme
            ? ButtonTextTheme.primary
            : ButtonTextTheme.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: color??(sharedProvider.isDarkTheme
            ? AppConstants.primarySwatch[50]
            : AppConstants.primarySwatch[800]),
        child: child,
      ),
    );
  }
}
