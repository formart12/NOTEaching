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
      print("체크리스트 에러 발생.: $e");
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
            Text("메모", style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _addCheckListController,
                  decoration: InputDecoration(
                    hintText: "+ 할일 추가",
                    hintStyle: Theme.of(context)
                        .textTheme
                        .labelSmall, // Apply theme to hint text
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                      ),
                    ),
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium, // Apply theme to text inside TextField
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _addCheckList(value);
                    }
                  },
                )),
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
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            await _deleteCheckList(index);
                            return true;
                          }
                          return false;
                        },
                        child: CheckboxListTile(
                          title: Text(
                            checkLists[index],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          value: isChecked[index],
                          onChanged: (bool? value) async {
                            await _updateCheckListStatus(index, value ?? false);
                          },
                          checkColor: Theme.of(context).colorScheme.onTertiary,
                          activeColor: Theme.of(context).colorScheme.tertiary,
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  Text(
                    "완료된 할일",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: completedCheckLists.length,
                    itemBuilder: (context, index) {
                      return Text(
                        completedCheckLists[index],
                        style: Theme.of(context).textTheme.labelSmall,
                      );
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
