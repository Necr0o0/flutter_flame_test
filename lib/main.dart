import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/absorb_game.dart';
import 'views/game_over_view.dart';
import 'views/main_menu_view.dart';
import 'views/hud_view.dart';
import 'views/pause_menu_view.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
        backgroundColor: Colors.black,
        body: SafeArea(
          child: GameWidget<AbsorbGame>(
            game: AbsorbGame(),
            overlayBuilderMap: {
              'MainMenu': (context, game) => MainMenuView(game: game),
              'GameOver': (context, game) => GameOverView(game: game),
              'HudOverlay': (context, game) => HudView(game: game),
              'PauseMenu': (context, game) => PauseMenuView(game: game)
            },
            // Display the MainMenu overlay as soon as the app starts
            initialActiveOverlays: const ['MainMenu'],
          ),
        ),
      ),
    );
  }
}