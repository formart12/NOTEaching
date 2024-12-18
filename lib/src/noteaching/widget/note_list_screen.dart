import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  Future<List<Map<String, dynamic>>> _fetchAllNotes() async {
    var snapshot =
        await FirebaseFirestore.instance.collection('calendar').get();
    return snapshot.docs.map((doc) {
      return {
        'date': doc['date'],
        'note': doc['note'],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        '메모 목록',
        style: Theme.of(context).textTheme.labelSmall,
      )),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAllNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              '저장된 메모가 없습니다.',
              style: Theme.of(context).textTheme.labelSmall,
            ));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final note = snapshot.data![index];
              return ListTile(
                title: Text(
                  note['note'],
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                    DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(note['date'])),
                    style: Theme.of(context).textTheme.labelSmall),
              );
            },
          );
        },
      ),
    );
  }
}
