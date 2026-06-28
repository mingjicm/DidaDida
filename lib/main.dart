import 'package:flutter/material.dart';
import 'app.dart';
import 'engines/metronome_engine.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final engine = MetronomeEngine();

  engine.init().then((_) {
    runApp(MetronomeApp(engine: engine));
  });
}
