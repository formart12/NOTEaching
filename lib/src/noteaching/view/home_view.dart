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
          title: Text(
            "NOTEaching",
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.tertiary,
            tabs: [
              Tab(
                child: Text(
                  "Home",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              Tab(
                child: Text(
                  "CheckList",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              Tab(
                child: Text(
                  "calendar",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
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
