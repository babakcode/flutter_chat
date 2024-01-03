import 'package:flutter/material.dart';
import 'package:flutter_chat/config/constants/constants.dart';
import 'package:flutter_chat/shared/presentation/providers/app_settings_provider/app_setting_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TemplatePage extends ConsumerStatefulWidget {
  static const route = '/template';

  const TemplatePage({super.key});

  @override
  ConsumerState createState() => _TemplatePageState();
}

class _TemplatePageState extends ConsumerState<TemplatePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final setting = ref.watch(appSettingAsyncProvider);

    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
                onPressed: () {
                  ref.read(appSettingAsyncProvider.notifier).darkMode = true;
                },
                icon: const Icon(Icons.dark_mode)),
            IconButton(
                onPressed: () {
                  ref.read(appSettingAsyncProvider.notifier).darkMode = false;
                },
                icon: const Icon(Icons.light_mode)),
            IconButton(
                onPressed: () {
                  ref.read(appSettingAsyncProvider.notifier).removeThemeMode();
                },
                icon: const Icon(Icons.mode_fan_off_outlined)),
          ],
        ),
        body:ClipRect(
          child: DecoratedBox(
            decoration: BoxDecoration(color: colorScheme.surface),
            child: Align(
              alignment: Alignment.topLeft,
              // widthFactor: widthAnimation.value,
              child: SingleChildScrollView(
                child: Card(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                largeWidthBreakpoint;
                              },
                              child: const Text('elevated')),
                          ElevatedButton.icon(
                            onPressed: () {},
                            label: const Text('elevated'),
                            icon: const Icon(Icons.access_alarm),
                          ),
                        ],
                      ),
                      MaterialButton(onPressed: () {}, child: const Text('material')),
                      FilledButton(onPressed: () {}, child: const Text('filled')),
                      FilledButton.tonal(onPressed: () {}, child: const Text('filled')),
                      OutlinedButton(onPressed: () {}, child: const Text('outlined')),
                      TextButton(onPressed: () {}, child: const Text('text')),
                      GridView.builder(
                        shrinkWrap: true,
                        itemCount: ColorSeed.values.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
                        itemBuilder: (context, index) {
                          ColorSeed seed = ColorSeed.values[index];
                          return IconButton(
                            onPressed: () {
                              ref.read(appSettingAsyncProvider.notifier).colorSeed = seed.label;
                            },
                            icon: Icon(
                              setting.whenData((value) => value.colorSeed).value == seed.label
                                  ? Icons.circle
                                  : Icons.circle_outlined,
                            ),
                            color: seed.color,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar:
            NavigationBar(selectedIndex: 0, destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.home), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.home), label: 'Login'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ]));
  }
}
