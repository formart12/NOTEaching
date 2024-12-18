import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String id;
  String title;
  String content;
  DateTime date;

  Note({
    this.id = '',
    required this.title,
    required this.content,
    required this.date,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      date: _parseDate(json['date']),
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    } else if (date is String) {
      return DateTime.parse(date);
    } else {
      throw FormatException("Invalid date format: $date");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'date': Timestamp.fromDate(date),
    };
  }
}
