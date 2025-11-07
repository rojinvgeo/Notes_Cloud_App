import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collection = 'notes';

  Stream<List<NoteModel>> getNotes(String uid) {
    return _db.collection(_collection)
      .where('userId', isEqualTo: uid)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((doc) => NoteModel.fromDoc(doc)).toList());
  }

  Future<void> addNote(NoteModel note) async {
    await _db.collection(_collection).add(note.toMap());
  }

  Future<void> updateNote(String id, Map<String, dynamic> data) async {
    await _db.collection(_collection).doc(id).update(data);
  }

  Future<void> deleteNote(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
}
