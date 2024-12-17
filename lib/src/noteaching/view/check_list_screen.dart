import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<String> checkLists = []; // Changed from tasks to checkLists
  List<bool> isChecked = [];
  List<String> completedCheckLists =
      []; // Changed from completedTasks to completedCheckLists
  final TextEditingController _addCheckListController =
      TextEditingController(); // Changed from _addTaskController
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch checklists from Firestore
  Future<void> _fetchCheckLists() async {
    // Changed from _fetchTasks to _fetchCheckLists
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('checkLists')
          .get(); // Changed from tasks to checkLists
      setState(() {
        checkLists = snapshot.docs
            .map((doc) => doc['checkList'] as String)
            .toList(); // Changed from task to checkList
        isChecked =
            snapshot.docs.map((doc) => doc['isChecked'] as bool).toList();
        completedCheckLists = snapshot.docs
            .where((doc) => doc['isChecked'] == true)
            .map((doc) =>
                doc['checkList'] as String) // Changed from task to checkList
            .toList();
      });
    } catch (e) {
      print("Error fetching checkLists: $e");
    }
  }

  // Add checkList to Firestore
  Future<void> _addCheckList(String checkList) async {
    // Changed from _addTask to _addCheckList
    try {
      await _firestore.collection('checkLists').add({
        // Changed from tasks to checkLists
        'checkList': checkList, // Changed from task to checkList
        'isChecked': false,
      });
      _fetchCheckLists(); // Reload checklists
      _addCheckListController.clear(); // Changed from _addTaskController
    } catch (e) {
      print("Error adding checkList: $e");
    }
  }

  // Update checkList completion status in Firestore
  Future<void> _updateCheckListStatus(int index, bool value) async {
    // Changed from _updateTaskStatus to _updateCheckListStatus
    try {
      final checkListDoc = await _firestore
          .collection('checkLists') // Changed from tasks to checkLists
          .where('checkList',
              isEqualTo: checkLists[index]) // Changed from task to checkList
          .get();
      if (checkListDoc.docs.isNotEmpty) {
        await _firestore
            .collection('checkLists') // Changed from tasks to checkLists
            .doc(checkListDoc.docs.first.id)
            .update({'isChecked': value});
        _fetchCheckLists(); // Reload checklists
      }
    } catch (e) {
      print("Error updating checkList status: $e");
    }
  }

  // Delete checkList from Firestore
  Future<void> _deleteCheckList(int index) async {
    // Changed from _deleteTask to _deleteCheckList
    try {
      final checkListDoc = await _firestore
          .collection('checkLists') // Changed from tasks to checkLists
          .where('checkList',
              isEqualTo: checkLists[index]) // Changed from task to checkList
          .get();
      if (checkListDoc.docs.isNotEmpty) {
        await _firestore
            .collection('checkLists')
            .doc(checkListDoc.docs.first.id)
            .delete(); // Changed from tasks to checkLists
        _fetchCheckLists(); // Reload checklists
      }
    } catch (e) {
      print("Error deleting checkList: $e");
    }
  }

  @override
  void dispose() {
    _addCheckListController.dispose(); // Changed from _addTaskController
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCheckLists(); // Fetch checklists when screen is loaded
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
                    controller:
                        _addCheckListController, // Changed from _addTaskController
                    decoration: const InputDecoration(
                      hintText: "+ 할일 추가",
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        _addCheckList(
                            value); // Changed from _addTask to _addCheckList
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
                    itemCount:
                        checkLists.length, // Changed from tasks to checkLists
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(checkLists[
                            index]), // Changed from tasks to checkLists
                        background: Container(
                          color: Colors.blue,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            await _deleteCheckList(
                                index); // Changed from _deleteTask to _deleteCheckList
                            return true;
                          }
                          return false;
                        },
                        child: CheckboxListTile(
                          title: Text(checkLists[
                              index]), // Changed from tasks to checkLists
                          value: isChecked[index],
                          onChanged: (bool? value) async {
                            await _updateCheckListStatus(
                                index,
                                value ??
                                    false); // Changed from _updateTaskStatus to _updateCheckListStatus
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
                    itemCount: completedCheckLists
                        .length, // Changed from completedTasks to completedCheckLists
                    itemBuilder: (context, index) {
                      return Text(completedCheckLists[
                          index]); // Changed from completedTasks to completedCheckLists
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
