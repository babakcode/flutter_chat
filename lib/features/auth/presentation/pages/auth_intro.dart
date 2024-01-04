import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthIntroPage extends ConsumerStatefulWidget {
  static const route = '/auth';
  const AuthIntroPage({super.key});

  @override
  ConsumerState createState() => _AuthIntroPageState();
}

class _AuthIntroPageState extends ConsumerState<AuthIntroPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
