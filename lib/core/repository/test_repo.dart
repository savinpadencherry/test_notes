// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_null_comparison
// ignore_for_file: unrelated_type_equality_checks, unused_import

import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import 'package:test_flutter/core/logger.dart';
import 'package:test_flutter/core/models/notes.dart';
import 'package:test_flutter/core/repository/databasehelper.dart';

class TestRepository with LogMixin, ChangeNotifier {
  List<Note> noteModels = [];
  final String tableName = 'notes';

  late DatabaseHelper dbHelper;
  TestRepository({
    required this.dbHelper,
  });

  List<Note> get notes => noteModels;

  Future<bool> checkInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> addNote(Note note) async {
    // Insert the note into the database
    await dbHelper.insertNote(note);
    noteModels.add(note);
    warningLog('checking for notemodels while adding $noteModels');
    bool connect = await checkInternetConnection();
    warningLog('Checking for connectivity $connect');
    if (connect == true) {
      addNotesToDb(note: note);
    }
    notifyListeners();
  }

  Future<void> updateNote(Note updatedNote) async {
    // Update the note in the database
    await dbHelper.updateNote(updatedNote);
    final index = noteModels.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      noteModels[index] = updatedNote;
      bool connect = await checkInternetConnection();
      warningLog('connectivity $connect');
      if (connect == true) {
        updateNotesToDb(note: updatedNote);
      }
      notifyListeners();
    }
  }

  Future<void> loadNotes() async {
    await dbHelper.initDatabase();
    noteModels = await dbHelper.getAllNotes();
    warningLog('calling noteModels while loading  $noteModels');
    notifyListeners();
  }

  Future<void> deleteNote(int noteId) async {
    // Delete the note from the database
    await dbHelper.deleteNote(noteId);
    noteModels.removeWhere((note) => note.id == noteId);
    bool connect = await checkInternetConnection();
    warningLog('connectivity $connect');
    if (connect == true) {
      deleteNoteByCustomId(noteId);
    }
    notifyListeners();
  }

  Future<void> deleteNoteByCustomId(int customNoteId) async {
    final url =
        Uri.parse('https://notees-376b2-default-rtdb.firebaseio.com/note.json');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final matchingNote = data.entries.firstWhere(
        (entry) => entry.value['id'] == customNoteId,
      );

      if (matchingNote != null) {
        final existingNoteId = matchingNote.key;
        await http.delete(
          Uri.parse(
              'https://notees-376b2-default-rtdb.firebaseio.com/note/$existingNoteId.json'),
        );
        warningLog(
            'Note with customNoteId $customNoteId deleted successfully.');
      } else {
        warningLog('Note with customNoteId $customNoteId not found.');
      }
    } catch (e) {
      warningLog('Error deleting note: $e');
    }
  }

  addNotesToDb({required Note note}) async {
    final url =
        Uri.parse('https://notees-376b2-default-rtdb.firebaseio.com/note.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'id': note.id,
            'title': note.title,
            'content': note.content,
          },
        ),
      );
      warningLog(
          'Checking for response ${response.statusCode} and response ${response.body}');
      final responseBody = json.decode(response.body);
      warningLog(
          'the response data ${responseBody.values.first} ${responseBody.keys}');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateNotesToDb({required Note note}) async {
    final customNoteId = note.id; // Replace with your actual custom note ID
    final url =
        Uri.parse('https://notees-376b2-default-rtdb.firebaseio.com/note.json');
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      warningLog('Checking update data $data');
      final matchingNote = data.entries.firstWhere(
        (entry) => entry.value['id'] == customNoteId,
      );
      warningLog('matching Notes $matchingNote');
      if (matchingNote != null) {
        // Update the existing note
        final existingNoteId = matchingNote.key;
        final response = await http.patch(
          Uri.parse(
              'https://notees-376b2-default-rtdb.firebaseio.com/note/$existingNoteId.json'),
          body: json.encode(
            {
              'title': note.title,
              'id': note.id,
              'content': note.content,
            },
          ),
        );
        warningLog(
          'checking for update function db ${response.statusCode} and body ${response.body}',
        );
      } else {
        warningLog('Cant patch cause there is no data or network connection');
      }
    } catch (e) {
      rethrow;
    }
  }
}
