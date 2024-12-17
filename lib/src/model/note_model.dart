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

  // From JSON (Firestore data)
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] ?? '', // Ensure id is assigned
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      date: _parseDate(json['date']),
    );
  }

  // Helper function to handle both String and Timestamp cases
  static DateTime _parseDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate(); // Convert Timestamp to DateTime
    } else if (date is String) {
      return DateTime.parse(
          date); // Parse String to DateTime (if stored as String)
    } else {
      throw FormatException("Invalid date format: $date");
    }
  }

  // To JSON (Firestore document)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'date':
          Timestamp.fromDate(date), // Convert DateTime to Firestore Timestamp
    };
  }
}
