import 'package:flutter/material.dart';
import 'package:note_aching/src/noteaching/view/check_list_screen.dart';
import 'package:note_aching/src/noteaching/view/home_screen.dart';
import 'package:note_aching/src/noteaching/view/spell_check_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs for Home, Checklist, and Spell Check
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "NOTEaching",
            textAlign: TextAlign.right,
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'), // Home Tab
              Tab(text: 'Checklist'), // Checklist Tab
              Tab(text: 'Spell Check'), // Spell Check Tab
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(), // First tab: HomeScreen
            ChecklistScreen(), // Second tab: ChecklistScreen
            SpellCheckScreen(), // Third tab: SpellCheckScreen
          ],
        ),
      ),
    );
  }
}
