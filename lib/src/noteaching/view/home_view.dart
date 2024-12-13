import 'package:flutter/material.dart';
import 'package:note_aching/src/model/note_model.dart';
import 'package:note_aching/src/noteaching/widget/note_list_item.dart';
import 'package:note_aching/src/util/firebase_service.dart';
import 'add_note_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseService _firebaseService = FirebaseService();
  List<NoteModel> notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final fetchedNotes = await _firebaseService.fetchNotes();
    setState(() {
      notes = fetchedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notepad"),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return NoteListItem(note: notes[index], onDelete: _fetchNotes);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNoteView()),
          );
          _fetchNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
