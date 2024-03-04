import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Note {
  int id;
  String title;
  String content; // Add a flag for sync status

  Note({
    required this.id,
    required this.title,
    required this.content,
  });

  Note copyWith({
    int? id,
    int? isSynced,
    String? title,
    String? content,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) =>
      Note.fromMap(json.decode(source) as Map<String, dynamic>);
  List<Object?> get props => [
        id,
        title,
        content,
      ];
}
