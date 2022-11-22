import 'package:chat_babakcode/providers/global_setting_provider.dart';
import 'package:chat_babakcode/ui/pages/chat/chat_page.dart';
import 'package:chat_babakcode/ui/pages/home/home_setting.dart';
import 'package:chat_babakcode/ui/pages/home/home_rooms.dart';
import 'package:chat_babakcode/utils/hive_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/room.dart';
import '../../../providers/chat_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChatProvider? chatProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    chatProvider?.connectSocket();
  }

  @override
  void dispose() {
    chatProvider?.socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

    final globalSetting = context.watch<GlobalSettingProvider>();
    final double _width = MediaQuery.of(context).size.width;
    globalSetting.checkDeviceDetermination(_width);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                if (_width > 960)
                  const SizedBox(width: 260, child: HomeSettingComponent()),
                if (_width < 600)
                  const Expanded(child: HomeRoomsComponent())
                else
                  ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: const HomeRoomsComponent()),
                if (_width > 600) const Expanded(child: ChatPage())
              ],
            ),
          ),
        ],
      ),
    );
  }
}
