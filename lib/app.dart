import 'package:flutter/material.dart';
import 'engines/metronome_engine.dart';
import 'screens/home_screen.dart';

class MetronomeApp extends StatefulWidget {
  final MetronomeEngine engine;

  const MetronomeApp({super.key, required this.engine});

  @override
  State<MetronomeApp> createState() => _MetronomeAppState();
}

class _MetronomeAppState extends State<MetronomeApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '节拍器',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF5C6BC0),
        brightness: Brightness.light,
      ),
      home: HomeScreen(engine: widget.engine),
    );
  }
}
