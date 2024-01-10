import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final String? description;
  final DateTime date;
  final String id;
  final String? organizerId;
  final List<String>? participants;
  Event({
    required this.title,
    this.description,
    required this.date,
    required this.id,
    this.organizerId,
    this.participants,
  });

  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    final Timestamp timestamp = data['date'];
    final DateTime date = timestamp.toDate();

    return Event(
      date: date,
      title: data['title'],
      description: data['description'],
      id: snapshot.id,
      organizerId: data['organizerId'] ?? "unknown",
      participants: List<String>.from(data['participants']?? []),
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "date": Timestamp.fromDate(date),
      "title": title,
      "description": description,
      "organizerId": organizerId,
      "participants": participants,
    };
  }
}