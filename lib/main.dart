import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:note_aching/src/noteaching/view/home_view.dart';
import 'package:note_aching/src/util/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeView(),
    );
  }
}
