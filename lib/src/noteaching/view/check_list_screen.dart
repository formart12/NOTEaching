import 'package:flutter/material.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<String> tasks = [
    "항목 1",
    "항목 2",
    "항목 3",
  ];

  List<bool> isChecked = [false, false, false, false];
  List<String> completedTasks = [];

  void _onTaskChecked(bool? value, int index) {
    setState(() {
      isChecked[index] = value ?? false;
      if (value == true) {
        completedTasks.add(tasks[index]);
      } else {
        completedTasks.remove(tasks[index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Checklist",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Task List
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(tasks[index]),
                  value: isChecked[index],
                  onChanged: (bool? value) {
                    _onTaskChecked(value, index);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Completed Tasks List
          const Text(
            "Completed Tasks",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...completedTasks.map((task) => Text(task)),
        ],
      ),
    );
  }
}
