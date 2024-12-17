import 'package:flutter/material.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<String> tasks = [];
  List<bool> isChecked = [];
  List<String> completedTasks = [];
  final TextEditingController _addTaskController = TextEditingController();
  final TextEditingController _editTaskController = TextEditingController();

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

  void _addTask(String task) {
    setState(() {
      tasks.add(task);
      isChecked.add(false);
      _addTaskController.clear();
    });
  }

  void _editTask(int index, String newTask) {
    setState(() {
      tasks[index] = newTask;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      completedTasks.remove(tasks[index]);
      tasks.removeAt(index);
      isChecked.removeAt(index);
    });
  }

  void _showEditDialog(int index) {
    _editTaskController.text = tasks[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("수정하기"),
          content: TextField(
            controller: _editTaskController,
            decoration: const InputDecoration(hintText: "수정할 내용을 입력하세요."),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _editTaskController.clear();
                Navigator.of(context).pop();
              },
              child: const Text("취소"),
            ),
            TextButton(
              onPressed: () {
                if (_editTaskController.text.trim().isNotEmpty) {
                  _editTask(index, _editTaskController.text.trim());
                }
                _editTaskController.clear();
                Navigator.of(context).pop();
              },
              child: const Text("저장"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _addTaskController.dispose();
    _editTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "메모",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addTaskController,
                    decoration: const InputDecoration(
                      hintText: "+ 할일 추가",
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        _addTask(value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(tasks[index]),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.grey[300],
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 8),
                              Icon(Icons.delete, color: Colors.black),
                            ],
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            _showEditDialog(index);
                            return false;
                          } else if (direction == DismissDirection.startToEnd) {
                            _deleteTask(index);
                            return true;
                          }
                          return false;
                        },
                        child: CheckboxListTile(
                          title: Text(tasks[index]),
                          value: isChecked[index],
                          onChanged: (bool? value) {
                            _onTaskChecked(value, index);
                          },
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  const Text(
                    "완료된 할일",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: completedTasks.length,
                    itemBuilder: (context, index) {
                      return Text(completedTasks[index]);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
