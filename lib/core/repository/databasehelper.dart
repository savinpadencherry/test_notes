// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_flutter/core/models/notes.dart';

class DatabaseHelper with ChangeNotifier {
  late Database _db;

  Future<void> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'notes.db');

    _db = await openDatabase(
      path,
      version: 2, // Increment the version number
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY,
          title TEXT,
          content TEXT 
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion == 1 && newVersion == 2) {
          // Add the "isSynced" column
          db.execute('ALTER TABLE notes ADD COLUMN isSynced BOOLEAN DEFAULT 0');
        }
      },
    );
  }

  Future<void> insertNote(Note note) async {
    await _db.insert(
      'notes',
      {
        'id': note.id,
        'title': note.title,
        'content': note.content,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateNote(Note updatedNote) async {
    await _db.update(
      'notes',
      {
        'id': updatedNote.id,
        'title': updatedNote.title,
        'content': updatedNote.content,
      },
      where: 'id = ?',
      whereArgs: [updatedNote.id],
    );
  }

  Future<void> deleteNote(int noteId) async {
    await _db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

  Future<List<Note>> getAllNotes() async {
    final List<Map<String, dynamic>> maps = await _db.query('notes');
    return List.generate(maps.length, (index) {
      return Note(
        id: maps[index]['id'],
        title: maps[index]['title'],
        content: maps[index]['content'],
      );
    });
  }
}
