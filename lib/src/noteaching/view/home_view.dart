import 'package:flutter/material.dart';
import 'package:note_aching/src/noteaching/view/calendar_screen.dart';
import 'package:note_aching/src/noteaching/view/check_list_screen.dart';
import 'package:note_aching/src/noteaching/view/home_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "NOTEaching",
            textAlign: TextAlign.right,
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Checklist'),
              Tab(text: 'Calendar'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            HomeScreen(),
            ChecklistScreen(),
            CalendarScreen(),
          ],
        ),
      ),
    );
  }
}
