import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerData {
  // Reactive state variables
  final ValueNotifier<int> lives = ValueNotifier<int>(3);
  final ValueNotifier<int> score = ValueNotifier<int>(0);
  final ValueNotifier<int> highScore = ValueNotifier<int>(0);

  // Initialize the high score from local storage
  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore.value = prefs.getInt('highScore') ?? 0;
  }

  // Reset for a new playthrough
  void reset() {
    lives.value = 3; 
    score.value = 0;
  }

  // Check and save high score at the end of a run
  Future<void> checkAndSaveHighScore() async {
    if (score.value > highScore.value) {
      highScore.value = score.value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('highScore', score.value);
    }
  }
}