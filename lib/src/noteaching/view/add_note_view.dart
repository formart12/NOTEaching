import 'package:flutter/material.dart';
import 'package:note_aching/src/model/note_model.dart';
import 'package:note_aching/src/util/firebase_service.dart';

class AddNoteView extends StatelessWidget {
  const AddNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    final FirebaseService firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Content"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final note = NoteModel(
                  id: '',
                  title: titleController.text,
                  content: contentController.text,
                  createdAt: DateTime.now(),
                );
                await firebaseService.addNote(note);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
