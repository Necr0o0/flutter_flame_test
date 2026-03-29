import 'package:flutter/material.dart';
import '../game/game.dart';

class HudOverlay extends StatelessWidget {
  final AbsorbGame game;

  const HudOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // We place this in a SafeArea so it doesn't overlap with phone notches
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Listen to the score notifier
            ValueListenableBuilder<int>(
              valueListenable: game.playerData.score,
              builder: (context, currentScore, child) {
                return Text(
                  'Score: $currentScore',
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            // Listen to the lives notifier
            ValueListenableBuilder<int>(
              valueListenable: game.playerData.lives,
              builder: (context, currentLives, child) {
                return Text(
                  'Lives: $currentLives',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}