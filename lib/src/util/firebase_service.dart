import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_aching/src/model/note_model.dart';

class FirebaseService {
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  // Fetch notes from Firestore
  Future<List<NoteModel>> fetchNotes() async {
    QuerySnapshot snapshot = await notesCollection.orderBy('createdAt').get();
    return snapshot.docs
        .map((doc) =>
            NoteModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Add a new note
  Future<void> addNote(NoteModel note) async {
    await notesCollection.add(note.toMap());
  }

  // Update an existing note
  Future<void> updateNote(NoteModel note) async {
    await notesCollection.doc(note.id).update(note.toMap());
  }

  // Delete a note
  Future<void> deleteNote(String id) async {
    await notesCollection.doc(id).delete();
  }
}
