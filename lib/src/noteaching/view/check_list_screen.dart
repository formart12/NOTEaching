import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  List<String> checkLists = [];
  List<bool> isChecked = [];
  List<String> completedCheckLists = [];
  final TextEditingController _addCheckListController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _fetchCheckLists() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('checkLists').get();
      setState(() {
        checkLists =
            snapshot.docs.map((doc) => doc['checkList'] as String).toList();
        isChecked =
            snapshot.docs.map((doc) => doc['isChecked'] as bool).toList();
        completedCheckLists = snapshot.docs
            .where((doc) => doc['isChecked'] == true)
            .map((doc) => doc['checkList'] as String)
            .toList();
      });
    } catch (e) {
      print("Error fetching checkLists: $e");
    }
  }

  Future<void> _addCheckList(String checkList) async {
    try {
      await _firestore.collection('checkLists').add({
        'checkList': checkList,
        'isChecked': false,
      });
      _fetchCheckLists();
      _addCheckListController.clear();
    } catch (e) {
      print("Error adding checkList: $e");
    }
  }

  Future<void> _updateCheckListStatus(int index, bool value) async {
    try {
      final checkListDoc = await _firestore
          .collection('checkLists')
          .where('checkList', isEqualTo: checkLists[index])
          .get();
      if (checkListDoc.docs.isNotEmpty) {
        await _firestore
            .collection('checkLists')
            .doc(checkListDoc.docs.first.id)
            .update({'isChecked': value});
        _fetchCheckLists();
      }
    } catch (e) {
      print("Error updating checkList status: $e");
    }
  }

  Future<void> _deleteCheckList(int index) async {
    try {
      final checkListDoc = await _firestore
          .collection('checkLists')
          .where('checkList', isEqualTo: checkLists[index])
          .get();
      if (checkListDoc.docs.isNotEmpty) {
        await _firestore
            .collection('checkLists')
            .doc(checkListDoc.docs.first.id)
            .delete();
        _fetchCheckLists();
      }
    } catch (e) {
      print("Error deleting checkList: $e");
    }
  }

  @override
  void dispose() {
    _addCheckListController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchCheckLists();
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
                    controller: _addCheckListController,
                    decoration: const InputDecoration(
                      hintText: "+ 할일 추가",
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        _addCheckList(value);
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
                    itemCount: checkLists.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(checkLists[index]),
                        background: Container(
                          color: Colors.blue,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            await _deleteCheckList(index);
                            return true;
                          }
                          return false;
                        },
                        child: CheckboxListTile(
                          title: Text(checkLists[index]),
                          value: isChecked[index],
                          onChanged: (bool? value) async {
                            await _updateCheckListStatus(index, value ?? false);
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
                    itemCount: completedCheckLists.length,
                    itemBuilder: (context, index) {
                      return Text(completedCheckLists[index]);
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
