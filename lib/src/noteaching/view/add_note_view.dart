import 'package:flutter/material.dart';
import 'package:note_aching/src/model/note_model.dart';
import 'package:note_aching/src/util/firebase_service.dart';

class AddNoteView extends StatefulWidget {
  final Note? existingNote;

  const AddNoteView({super.key, this.existingNote});

  @override
  _AddNoteViewState createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingNote != null) {
      _titleController.text = widget.existingNote!.title;
      _contentController.text = widget.existingNote!.content;
    }
  }

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          '내용을 입력해주세요.',
          style: Theme.of(context).textTheme.labelSmall,
        )),
      );
      return;
    }

    final note = Note(
      id: widget.existingNote?.id ?? '',
      title: _titleController.text,
      content: _contentController.text,
      date: DateTime.now(),
    );

    try {
      if (widget.existingNote != null) {
        await FirebaseService().updateNote(note.id, note);
      } else {
        await FirebaseService().saveNote(note);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          '오류로 인해 저장하지 못했습니다.: $e',
          style: Theme.of(context).textTheme.labelSmall,
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingNote != null ? '메모 수정' : '새 메모',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _titleController,
              decoration: InputDecoration(
                  hintText: '제목',
                  hintStyle: Theme.of(context).textTheme.bodyMedium),
              maxLines: null,
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: TextField(
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: _contentController,
                  decoration: InputDecoration(
                      hintText: '내용',
                      hintStyle: Theme.of(context).textTheme.bodyMedium),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text(
                widget.existingNote != null ? '수정' : '저장',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
