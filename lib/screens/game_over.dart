import 'package:flutter/material.dart';
import '../game/game.dart';

class GameOverScreen extends StatelessWidget {
  final AbsorbGame game;

  const GameOverScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87, // Slightly darker than the main menu
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 20),
            // Display the final score here
            Text(
              'Final Score: ${game.score}',
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Remove the Game Over screen
                game.overlays.remove('GameOver');
                game.cleanLevel();
                // Resume the game engine
                game.resumeEngine();
                // Restart the game state
                game.overlays.add('MainMenu'); // Show the main menu again for a fresh start
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}