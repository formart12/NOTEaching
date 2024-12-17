import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_aching/src/model/note_model.dart';
import 'package:note_aching/src/noteaching/widget/note_list_item.dart';
import 'add_note_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];

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

          notes = snapshot.data!.docs.map((doc) => doc.data()).toList();
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteListItem(
                note: note,
                onDelete: () {
                  setState(() {
                    notes.removeAt(index);
                  });
                },
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
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
