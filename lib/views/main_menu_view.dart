import 'package:flutter/material.dart';
import '../game/absorb_game.dart';

class MainMenuView extends StatelessWidget {
  final AbsorbGame game;

  const MainMenuView({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54, // Semi-transparent background
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ABSORB',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                game.startGame();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Text('Start Game'),
            ),
          ],
        ),
      ),
    );
  }
}