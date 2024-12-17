import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_aching/src/model/note_model.dart'; // Make sure you're importing the correct model

class NoteListItem extends StatelessWidget {
  final Note note; // Correct class name here
  final Function onDelete;

  const NoteListItem({super.key, required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text(note.content),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          // Delete note logic
          try {
            await FirebaseFirestore.instance
                .collection('notes')
                .doc(note.id) // Use the note id for the Firestore document
                .delete();
            onDelete(); // Call onDelete to refresh the list after deletion
          } catch (e) {
            // Handle errors if any during deletion
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error deleting note: $e')),
            );
          }
        },
      ),
    );
  }
}
