# Absorb - Flutter Flame Mobile Game

This repository contains the implementation of the "Absorb" mobile game, built using Flutter (Dart 3, null safety) and the Flame Engine. The codebase is treated as a fragment of a production-ready application rather than a quick prototype, prioritizing clean architecture, maintainability, and scalability.

---

## Architecture & Naming Conventions

To ensure a highly scalable architecture and a clean separation of concerns, the project implements a strict, Unity/ECS-inspired file structure. This perfectly isolates the rendering engine from the business logic and the UI layer.

* **`/game/` (`...Game`):** The core `FlameGame` root that acts as the context for states and UI routing.
* **`/states/` (`...State`):** Implementations of the Gang of Four State Pattern handling game lifecycle transitions.
* **`/scenes/` (`...Scene`):** The root nodes for specific game phases (e.g., `GameplayScene`) that manage the lifecycle of the entities inside them.
* **`/entities/` (`...Entity`):** The physical actors in the game world with hitboxes and graphics (e.g., `AbsorberEntity`, `GoodBallEntity`).
* **`/components/` (`...Component`):** Reusable, headless logic nodes attached to entities (e.g., `Physics2DComponent`).
* **`/managers/` (`...Manager`):** Invisible logic controllers handling object spawning and pooling.
* **`/data/` (`...Data`):** Pure state and local storage logic (e.g., `PlayerData`).
* **`/views/` (`...View`):** Standard Flutter Widgets built as overlays on top of the engine (e.g., `MainMenuView`, `HudView`).

---

## Design Patterns & Technical Decisions

### 1. Finite State Machine (Gang of Four)
To avoid spaghetti code and tight coupling in the core engine, game routing is handled via a strict **State Pattern**. 
* The `AbsorbGame` acts as a "dumb" context, delegating all UI routing, pause logic, and scene management to concrete states (`MenuState`, `PlayingState`, `PausedState`, etc.). 
* This fulfills the **Open/Closed Principle**, allowing new game states (like a Cutscene or Tutorial) to be added without modifying the core engine class.

### 2. Composition Over Inheritance (ECS Approach)
Entities are kept highly modular. 
* Movement and screen-boundary math are completely abstracted into a reusable `Physics2DComponent`. The entities act purely as data and graphical containers.
* **Event Dispatching:** The `AbsorberEntity` does not hold references to the overarching game or scene. It communicates completely via `VoidCallbacks` (Signals/Dispatchers), allowing the `GameplayScene` to handle the business logic of scoring and taking damage.

### 3. State Management & Data Flow (Why Not BLoC?)
While BLoC is an excellent tool for standard Flutter apps, implementing it for purely synchronous, frame-by-frame physics tracking introduces unnecessary asynchronous overhead and violates the **KISS (Keep It Simple, Stupid)** principle. 

Instead, the data flow relies on an MVP (Model-View-Presenter) approach using Flutter's native `ValueNotifier`. 
* **The Model:** `PlayerData` acts as the single source of truth for lives and score.
* **The View:** `HudView` uses `ValueListenableBuilder` to surgically rebuild only the text widgets when integers change, entirely decoupled from the 60 FPS Flame rendering loop.

### 4. Scene Graph & Game Lifecycle
Managing the game lifecycle effectively is critical to prevent memory leaks and "ghost collisions". 
* All core gameplay is encapsulated within the `GameplayScene`. 
* When navigating to the Main Menu or transitioning from a Game Over state, the entire `GameplayScene` is detached from the Flame component tree and destroyed. This mathematically guarantees clean state resets.

### 5. Dynamic Object Pooling
To maintain a stable framerate on mobile devices and prevent Garbage Collection spikes, `BallManager` utilizes a **Dynamic Object Pool**.
* Entities are pre-allocated in memory upon initialization.
* When an entity goes off-screen or is absorbed, it is removed from the Flame visual tree (`removeFromParent()`) but recycled within the manager's memory array.

### 6. Data Persistence & Concurrency
Adhering to the Single Responsibility Principle, the Flame Engine does not handle data saving. The `PlayerData` class manages local storage via the `shared_preferences` package. Initialization is handled concurrently using `Future.wait()` to ensure maximum boot speed.

### 7. Platform & UX Polish
* **System Gestures:** The `GameWidget` is wrapped in a `SafeArea` to prevent the player's frantic swipes from accidentally triggering iOS/Android system navigation bars.
* **App Lifecycle:** The game listens to `AppLifecycleState`. If the app is minimized, the engine automatically routes to the `PausedState`.
* **Safe Spawning:** The spawner calculates a dynamic safe zone based on the Absorber's current radius, mathematically preventing enemies from spawning directly on top of the player.

---

## How to Build and Run

Ensure you have the Flutter SDK installed and configured for mobile development.

**1. Run in Debug Mode (Emulator or connected device):**
```bash
flutter clean
flutter pub get
flutter run
```
**2. Build a Release APK for Android:**

```bash
flutter build apk --release
```

The resulting file will be located at build/app/outputs/flutter-apk/app-release.apk and can be installed directly on any Android device.