import 'package:flutter/material.dart';
import 'package:flutter_chat/features/auth/presentation/pages/auth_intro.dart';
import 'package:flutter_chat/features/home/presentation/pages/home_page.dart';
import 'package:flutter_chat/shared/presentation/providers/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  static const route = '/splash';

  const SplashPage({super.key});

  @override
  ConsumerState createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
      () {
        ref.read(authProvider.future).then((setting) {
          context.go((setting.loggedIn ?? false)
              ? HomePage.route
              : AuthIntroPage.route);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Splash"),
    );
  }
}
