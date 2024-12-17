import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_aching/src/model/note_model.dart';
import 'add_note_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesRef =
        FirebaseFirestore.instance.collection('notes').withConverter<Note>(
              fromFirestore: (snapshots, _) => Note.fromJson(snapshots.data()!),
              toFirestore: (note, _) => note.toJson(),
            );

    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Note>>(
        stream: notesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.requireData.docs;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index].data(); // Note type here
              return Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddNoteView()),
        ),
        tooltip: '메모 추가하기',
        child: const Icon(Icons.add),
      ),
    );
  }
}
