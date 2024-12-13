import 'package:flutter/material.dart';
import 'package:note_aching/src/model/note_model.dart';
import 'package:note_aching/src/util/firebase_service.dart';

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
          final firebaseService = FirebaseService();
          await firebaseService.deleteNote(note.id);
          onDelete();
        },
      ),
    );
  }
}
