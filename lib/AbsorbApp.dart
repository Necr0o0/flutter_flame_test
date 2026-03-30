import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/absorb_game.dart';
import 'views/game_over_view.dart';
import 'views/main_menu_view.dart';
import 'views/hud_view.dart';
import 'views/pause_menu_view.dart';

/// The main application widget for the Absorb mobile game.
/// 
/// This widget serves as the root of the Flutter application and sets up the
/// game environment with proper theming, navigation, and overlay management.
/// It uses Flame's GameWidget to render the game and manages the overlay
/// views for different game states.
class AbsorbApp extends StatelessWidget {
  /// Creates an instance of the AbsorbApp widget.
  /// 
  /// The key parameter is used for widget identification and is passed to the
  /// superclass constructor.
  const AbsorbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// The title of the application displayed in the app bar and task switcher.
      title: 'Absorb',
      
      /// Hides the debug banner that appears in debug mode for a cleaner UI.
      debugShowCheckedModeBanner: false,
      
      /// Uses a dark theme to match the game's aesthetic and reduce eye strain.
      theme: ThemeData.dark(),
      
      /// The home scaffold provides the basic structure for the game interface.
      home: Scaffold(
        /// Sets the background color to black to match the game's theme.
        backgroundColor: Colors.black,
        
        /// Wraps the game content in a SafeArea to prevent system gestures
        /// from interfering with gameplay on mobile devices.
        body: SafeArea(
          child: GameWidget<AbsorbGame>(
            /// Creates the main game instance that manages all game states.
            game: AbsorbGame(),
            
            /// Maps overlay names to their corresponding view builders.
            /// These overlays are displayed on top of the game when needed.
            overlayBuilderMap: {
              /// The main menu overlay displayed when the game starts.
              'MainMenuView': (context, game) => MainMenuView(game: game),
              
              /// The game over overlay displayed when the player loses.
              'GameOverView': (context, game) => GameOverView(game: game),
              
              /// The heads-up display showing score and lives.
              'HudView': (context, game) => HudView(game: game),
              
              /// The pause menu overlay displayed when the game is paused.
              'PauseMenuView': (context, game) => PauseMenuView(game: game)
            },
          ),
        ),
      ),
    );
  }
}