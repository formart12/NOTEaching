import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_aching/src/noteaching/view/home_view.dart';
import 'package:note_aching/src/util/app_theme.dart';
import 'firebase_options.dart'; // Firebase options file for proper initialization

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: light,
      darkTheme: dark,
      home: const HomeView(), // Navigate to HomeView
    );
  }
}
