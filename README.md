# Absorb - Flutter Flame Game

[cite_start]A mobile game built with Flutter and the Flame engine, developed as a recruitment task[cite: 1, 3, 4]. 

## 🏗 Architecture & Design Patterns

[cite_start]The codebase was designed with **SOLID** and **KISS** principles in mind, treating the project as a fragment of a production-ready application rather than a quick prototype[cite: 21].

### 1. Scene Management (Game Lifecycle)
Instead of relying on a single "God Class" to handle all game logic and state gating, the game utilizes a Unity-inspired **Scene Graph Architecture**. 
* Core gameplay logic (Player, Object Spawners) is encapsulated within a `GameplayScene` component. 
* When the player navigates to the Main Menu or restarts, the entire `GameplayScene` is detached and destroyed. [cite_start]This mathematically guarantees zero memory leaks, eliminates "ghost collisions" in the background, and provides perfectly clean state resets[cite: 20, 23].

### 2. Dynamic Object Pooling
To maintain a stable 60 FPS and prevent Garbage Collection stutters, the game uses a **Dynamic Object Pool** (`BallManager`).
* [cite_start]40 objects of each type (Good/Bad balls) are pre-allocated in memory[cite: 6].
* When a ball is absorbed or goes off-screen, it is detached from the Flame component tree but kept in the pool's memory.
* [cite_start]If the screen fills up and the pool is exhausted, the manager dynamically allocates new balls to accommodate the increasing difficulty[cite: 11].

### 3. State Management & Data Flow
While BLoC is a powerful tool, implementing it for purely synchronous, frame-by-frame physics tracking introduces unnecessary asynchronous overhead and violates the KISS principle. 
* **State Management:** The game utilizes Flutter's native `ValueNotifier` and `ValueListenableBuilder` for the HUD. [cite_start]This completely decouples the Flame engine's rendering loop from the Flutter UI layer[cite: 22, 29]. The UI only rebuilds exactly when the `score` or `lives` integers change.

### 4. Platform & UX Polish
* **App Lifecycle:** The game integrates with Flutter's `AppLifecycleState`. [cite_start]If the app is minimized or the user switches tabs, the engine automatically pauses and routes to a dedicated Pause Overlay[cite: 23].
* **System Gestures:** The `GameWidget` is wrapped in a `SafeArea` to prevent the player's frantic bottom-screen swipes from accidentally triggering iOS/Android system navigation bars.
* **Fair Spawning:** The spawner calculates a dynamic safe zone based on the Absorber's current radius, preventing enemies from spawning directly on top of the player.

##  How to Run

[cite_start]Ensure you are running Dart 3 with null safety enabled[cite: 16].

```bash
flutter clean
flutter pub get
flutter run