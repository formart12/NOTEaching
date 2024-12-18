import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_aching/src/model/note_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveNote(Note note) async {
    try {
      DocumentReference docRef =
          await _db.collection('notes').add(note.toJson());

      note.id = docRef.id;
      await docRef.update({'id': note.id});
    } catch (e) {
      throw 'Error saving note: $e';
    }
  }

  Stream<QuerySnapshot<Note>> getNotesStream() {
    return _db
        .collection('notes')
        .withConverter<Note>(
          fromFirestore: (snapshots, _) => Note.fromJson(snapshots.data()!),
          toFirestore: (note, _) => note.toJson(),
        )
        .snapshots();
  }

  Future<void> updateNote(String id, Note note) async {
    try {
      await _db.collection('notes').doc(id).update(note.toJson());
    } catch (e) {
      throw 'Error updating note: $e';
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _db.collection('notes').doc(id).delete();
    } catch (e) {
      throw 'Error deleting note: $e';
    }
  }
}
