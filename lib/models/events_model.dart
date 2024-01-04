import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final String? description;
  final DateTime date;
  final String id;
  Event({
    required this.title,
    this.description,
    required this.date,
    required this.id,
  });

  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    print("Timestamp from Firestore: ${data['date']}");
    final Timestamp timestamp = data['date'];
    final DateTime date = timestamp.toDate();
    print("Converted DateTime: $date");

    return Event(
      date: date,
      title: data['title'],
      description: data['description'],
      id: snapshot.id,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "date": Timestamp.fromDate(date),
      "title": title,
      "description": description
    };
  }
}