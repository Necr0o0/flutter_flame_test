import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/game.dart';
import 'screens/game_over.dart';
import 'screens/main_menu.dart';

void main() {
  // Ensure Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const AbsorbApp());
}

class AbsorbApp extends StatelessWidget {
  const AbsorbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absorb',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: GameWidget<AbsorbGame>(
          game: AbsorbGame(),
          overlayBuilderMap: {
            'MainMenu': (context, game) => MainMenu(game: game),
            'GameOver': (context, game) => GameOverScreen(game: game),
          },
          // Display the MainMenu overlay as soon as the app starts
          initialActiveOverlays: const ['MainMenu'],
        ),
      ),
    );
  }
}