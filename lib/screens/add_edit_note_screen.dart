import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/note_model.dart';
import '../services/firestore_service.dart';
import 'home_screen.dart'; 

class AddEditNoteScreen extends StatefulWidget {
  final NoteModel? note;
  final String? userId;

  const AddEditNoteScreen({super.key, this.note, this.userId});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final titleCtl = TextEditingController();
  final contentCtl = TextEditingController();
  final _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleCtl.text = widget.note!.title;
      contentCtl.text = widget.note!.content;
    }
  }

  /// Save or update note, show success message, and robustly redirect to home
  Future<void> _save() async {
    if (titleCtl.text.trim().isEmpty && contentCtl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot save an empty note!')),
      );
      return;
    }

    try {
      if (widget.note == null) {
        // Add new note
        final newNote = NoteModel(
          id: const Uuid().v4(),
          title: titleCtl.text,
          content: contentCtl.text,
          createdAt: Timestamp.now(),
          userId: widget.userId!,
        );
        await _firestoreService.addNote(newNote);
      } else {
        // Update existing note
        await _firestoreService.updateNote(widget.note!.id, {
          'title': titleCtl.text,
          'content': contentCtl.text,
        });
      }

      // 1. Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note saved successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // 2. Wait 1 second, then navigate back to HomeScreen, removing all previous routes
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false, 
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving note: $e')),
      );
    }
  }

  /// Delete note with confirmation, show success message, and robustly redirect to home
  Future<void> _deleteNote() async {
    if (widget.note == null) return; 

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _firestoreService.deleteNote(widget.note!.id);

        // 1. Show success message for deletion
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note deleted successfully!'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // 2. Wait 1 second, then navigate back to HomeScreen, removing all previous routes
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false, 
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting note: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteNote,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleCtl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: contentCtl,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(), 
                ), 
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, 
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(widget.note == null ? 'Save New Note' : 'Update Note'),
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}