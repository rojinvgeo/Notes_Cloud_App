import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';
import '../services/firestore_service.dart';
import 'add_edit_note_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final notesStream = FirestoreService().getNotes(user.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            onPressed: () async => await FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: StreamBuilder<List<NoteModel>>(
        stream: notesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final notes = snapshot.data!;
          if (notes.isEmpty) return const Center(child: Text('No notes yet.'));
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, i) {
              final note = notes[i];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddEditNoteScreen(note: note)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddEditNoteScreen(userId: user.uid)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
