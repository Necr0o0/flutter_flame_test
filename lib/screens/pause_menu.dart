import 'package:flutter/material.dart';
import '../game/game.dart';

class PauseMenu extends StatelessWidget {
  final AbsorbGame game;

  const PauseMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54, // Semi-transparent so they can see the frozen game behind it
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PAUSED',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                game.resumePlaying();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Text('Resume'),
            )
          ],
        ),
      ),
    );
  }
}