import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/note_model.dart';

class FirebaseService {
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('notes');

  Future<List<NoteModel>> fetchNotes() async {
    QuerySnapshot snapshot = await notesCollection.orderBy('createdAt').get();
    return snapshot.docs
        .map((doc) =>
            NoteModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> addNote(NoteModel note) async {
    await notesCollection.add(note.toMap());
  }

  Future<void> updateNote(NoteModel note) async {
    await notesCollection.doc(note.id).update(note.toMap());
  }

  Future<void> deleteNote(String id) async {
    await notesCollection.doc(id).delete();
  }
}
