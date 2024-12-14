import 'package:flutter/material.dart';
import 'package:note_aching/src/noteaching/view/add_note_view.dart';

class HomeTextField extends StatelessWidget {
  const HomeTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNoteScreen(),
            ),
          );
          setState(() {}); // HomeScreen에서 데이터 갱신
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
