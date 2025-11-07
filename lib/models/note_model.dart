import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String content;
  final Timestamp createdAt;
  final String userId;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'userId': userId,
    };
  }

  factory NoteModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteModel(
      id: doc.id,
      title: data['title'],
      content: data['content'],
      createdAt: data['createdAt'],
      userId: data['userId'],
    );
  }
}
