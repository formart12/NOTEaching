import 'package:firebase_core/firebase_core.dart'; // Import Firebase
import 'package:flutter/material.dart';
import 'package:note_aching/src/noteaching/view/home_view.dart';
import 'package:note_aching/src/util/app_theme.dart'; // Import HomeView

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure proper initialization
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp()); // Run the app after Firebase initialization
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NOTEaching App',
      theme: light,
      darkTheme: dark,
      home: const HomeView(), // Set HomeView as the starting screen
    );
  }
}
