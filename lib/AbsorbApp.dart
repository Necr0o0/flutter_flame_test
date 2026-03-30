import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/absorb_game.dart';
import 'views/game_over_view.dart';
import 'views/main_menu_view.dart';
import 'views/hud_view.dart';
import 'views/pause_menu_view.dart';

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
              'MainMenuView': (context, game) => MainMenuView(game: game),
              'GameOverView': (context, game) => GameOverView(game: game),
              'HudView': (context, game) => HudView(game: game),
              'PauseMenuView': (context, game) => PauseMenuView(game: game)
            },
          ),
        ),
      ),
    );
  }
}