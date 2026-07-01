import 'package:flutter/material.dart';
import 'engines/metronome_engine.dart';
import 'screens/home_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/tuner_screen.dart';
import 'screens/settings_screen.dart';

class MetronomeApp extends StatefulWidget {
  final MetronomeEngine engine;

  const MetronomeApp({super.key, required this.engine});

  @override
  State<MetronomeApp> createState() => _MetronomeAppState();
}

class _MetronomeAppState extends State<MetronomeApp> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '嘀嗒嘀嗒',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF5C6BC0),
        brightness: Brightness.light,
      ),
      home: Scaffold(
        body: IndexedStack(
          index: _currentTab,
          children: [
            HomeScreen(engine: widget.engine),
            const PracticeScreen(),
            const TunerScreen(),
            SettingsScreen(engine: widget.engine),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentTab,
          onDestinationSelected: (i) => setState(() => _currentTab = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.speed_outlined),
              selectedIcon: Icon(Icons.speed),
              label: '节拍器',
            ),
            NavigationDestination(
              icon: Icon(Icons.sports_esports_outlined),
              selectedIcon: Icon(Icons.sports_esports),
              label: '趣味练习',
            ),
            NavigationDestination(
              icon: Icon(Icons.tune_outlined),
              selectedIcon: Icon(Icons.tune),
              label: '调音器',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: '设置',
            ),
          ],
        ),
      ),
    );
  }
}
