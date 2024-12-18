import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  List<DocumentSnapshot> _notes = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    initializeDateFormatting('ko_KR', null).then((_) {
      setState(() {});
    });
    _fetchNotesForSelectedDay();
  }

  Future<void> _fetchNotesForSelectedDay() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('calendar')
        .where('date', isEqualTo: _selectedDay.toIso8601String())
        .get();
    setState(() {
      _notes = snapshot.docs;
    });
  }

  Future<void> _saveNote(String title, String content) async {
    if (title.isNotEmpty && content.isNotEmpty) {
      await FirebaseFirestore.instance.collection('calendar').add({
        'date': _selectedDay.toIso8601String(),
        'title': title,
        'content': content,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text(
            '메모가 저장되었습니다.',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      );
      _fetchNotesForSelectedDay();
    }
  }

  Future<void> _deleteNote(String id) async {
    await FirebaseFirestore.instance.collection('calendar').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        content: Text(
          '메모가 삭제되었습니다.',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
    _fetchNotesForSelectedDay();
  }

  void _showAddNoteModal() {
    String title = '';
    String content = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (value) => title = value,
                decoration: InputDecoration(
                  hintText: '제목을 입력하세요.',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                style: Theme.of(context).textTheme.bodyMedium,
                onChanged: (value) => content = value,
                decoration: InputDecoration(
                  hintText: '메모 내용을 입력하세요.',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _saveNote(title, content);
                  Navigator.pop(context);
                },
                child: Text(
                  '저장',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditNoteModal(
      String noteId, String currentTitle, String currentContent) {
    String title = currentTitle;
    String content = currentContent;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController(text: title),
                onChanged: (value) => title = value,
                decoration: InputDecoration(
                  hintText: '제목을 입력하세요.',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                ),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(text: content),
                onChanged: (value) => content = value,
                decoration: InputDecoration(
                  hintText: '메모 내용을 입력하세요.',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                ),
                style: Theme.of(context).textTheme.labelSmall,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _updateNote(noteId, title, content);
                  Navigator.pop(context);
                },
                child: Text(
                  '저장',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _updateNote(String noteId, String title, String content) async {
    if (title.isNotEmpty && content.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('calendar')
          .doc(noteId)
          .update({
        'title': title,
        'content': content,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Text(
            '메모가 수정되었습니다.',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      );

      _fetchNotesForSelectedDay();
    }
  }

  Widget _buildNoteItem(DocumentSnapshot note) {
    final data = note.data() as Map<String, dynamic>;
    final title = data['title'] ?? '제목 없음';
    final content = data['content'] ?? '';
    final date = DateTime.parse(data['date']).toLocal();

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 20,
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      _showEditNoteModal(note.id, title, content);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 20,
                      color: Theme.of(context).colorScheme.surfaceContainer,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => _deleteNote(note.id),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                content,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  "${date.year}년 ${date.month}월 ${date.day}일",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 01, 01),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _fetchNotesForSelectedDay();
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                locale: 'ko_KR',
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: Theme.of(context).textTheme.labelSmall!,
                  weekendTextStyle: Theme.of(context).textTheme.bodySmall!,
                  outsideTextStyle: Theme.of(context).textTheme.bodySmall!,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '선택된 날짜: ${DateFormat('yyyy년 MM월 dd일').format(_selectedDay)}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return _buildNoteItem(_notes[index]);
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        onPressed: _showAddNoteModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
