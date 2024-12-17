import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_aching/src/model/note_model.dart';
import 'package:note_aching/src/noteaching/view/add_note_view.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final Function onDelete;

  const NoteListItem({
    super.key,
    required this.note,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.zero, // Remove padding around entire container
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Title
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Edit and Delete Icons
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero, // No padding applied
                    constraints:
                        const BoxConstraints(), // Remove constraints applied by default
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNoteView(existingNote: note),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero, // No padding applied
                    constraints:
                        const BoxConstraints(), // Remove constraints applied by default
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection('notes')
                            .doc(note.id)
                            .delete();
                        onDelete(); // Refresh the list
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error deleting note: $e')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                note.content,
                style: const TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ),
            // Date at the bottom-right corner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "${note.date.toLocal()}"
                      .split(' ')[0], // Display date in "YYYY-MM-DD" format
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
