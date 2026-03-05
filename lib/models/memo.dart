import 'package:uuid/uuid.dart';

class Memo {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  // New fields for multimedia paths
  final List<String> imagePaths;
  final List<String> videoPaths;
  final List<String> audioPaths;
  final List<String> drawingPaths; // Paths to saved signature/drawing images

  Memo({
    String? id,
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.imagePaths = const [],
    this.videoPaths = const [],
    this.audioPaths = const [],
    this.drawingPaths = const [],
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'imagePaths': imagePaths,
      'videoPaths': videoPaths,
      'audioPaths': audioPaths,
      'drawingPaths': drawingPaths,
    };
  }

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      imagePaths: List<String>.from(json['imagePaths'] ?? []),
      videoPaths: List<String>.from(json['videoPaths'] ?? []),
      audioPaths: List<String>.from(json['audioPaths'] ?? []),
      drawingPaths: List<String>.from(json['drawingPaths'] ?? []),
    );
  }
}
