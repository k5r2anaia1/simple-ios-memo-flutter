class Memo {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;

  Memo({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavorite': isFavorite,
    };
  }

  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Memo copyWith({
    String? title,
    String? content,
    bool? isFavorite,
  }) {
    return Memo(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
