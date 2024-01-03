import 'package:flutter_chat/features/intro/presentation/pages/splash_page.dart';
import 'package:flutter_chat/shared/presentation/pages/template_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: TemplatePage.route,
  routes: [
    GoRoute(
      path: SplashPage.route,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: TemplatePage.route,
      builder: (context, state) => const TemplatePage(),
    ),
  ],
);
