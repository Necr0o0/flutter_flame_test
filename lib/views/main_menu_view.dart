import 'package:flutter/material.dart';
import '../game/absorb_game.dart';

/// The main menu view displayed when the game starts.
/// 
/// This view provides a simple, centered interface with the game title and
/// a start button. It uses a semi-transparent black background to allow
/// the game scene to be partially visible underneath.
class MainMenuView extends StatelessWidget {
  /// Reference to the main game instance for state transitions.
  final AbsorbGame game;

  /// Creates a new main menu view.
  /// 
  /// [key]: Widget identification key
  /// [game]: Reference to the main game instance
  const MainMenuView({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      /// Semi-transparent black background for overlay effect
      color: Colors.black54,
      
      /// Center the content both vertically and horizontally
      child: Center(
        child: Column(
          /// Center children vertically with equal spacing
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Game title with large, bold white text
            const Text(
              'ABSORB',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            
            /// Vertical spacing between title and button
            const SizedBox(height: 40),
            
            /// Start button that transitions to the playing state
            ElevatedButton(
              onPressed: () {
                // Trigger the play action in the game state machine
                game.play();
              },
              
              /// Button styling with large padding and text size
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 24),
              ),
              
              /// Button label
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}