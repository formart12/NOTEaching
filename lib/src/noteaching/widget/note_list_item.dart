import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:note_aching/src/model/note_model.dart';

class NoteListItem extends StatelessWidget {
  final NoteModel note;
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
          await FirebaseFirestore.instance
              .collection('notes')
              .doc(note.id)
              .delete();
          onDelete(); // Call onDelete to refresh the list after deletion
        },
      ),
    );
  }
}
