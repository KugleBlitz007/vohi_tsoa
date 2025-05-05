import 'package:cloud_firestore/cloud_firestore.dart';

class TestItem {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  TestItem({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory TestItem.fromMap(Map<String, dynamic> map, String id) {
    return TestItem(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdAt': createdAt,
    };
  }
} 