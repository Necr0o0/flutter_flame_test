import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'AbsorbApp.dart';

/// The entry point of the Absorb mobile game application.
/// 
/// This file handles the initialization of Flutter bindings and sets the
/// preferred device orientation before launching the main application widget.
Future<void> main() async {
  // Ensure Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock the app to portrait orientation for consistent gameplay experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Launch the main application widget
  runApp(const AbsorbApp());
}
