import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/memo.dart';

class MemoProvider extends ChangeNotifier {
  List<Memo> _memos = [];

  List<Memo> get memos => _memos;

  MemoProvider() {
    _loadMemos();
  }

  Future<void> _loadMemos() async {
    final prefs = await SharedPreferences.getInstance();
    final memosJson = prefs.getStringList('memos');
    if (memosJson != null) {
      _memos = memosJson
          .map((jsonStr) => Memo.fromJson(json.decode(jsonStr)))
          .toList();
      _sortMemos();
      notifyListeners();
    }
  }

  Future<void> _saveMemos() async {
    final prefs = await SharedPreferences.getInstance();
    final memosJson = _memos.map((memo) => json.encode(memo.toJson())).toList();
    await prefs.setStringList('memos', memosJson);
  }

  void _sortMemos() {
    _memos.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  void addMemo(
    String title,
    String content, {
    List<String> images = const [],
    List<String> videos = const [],
    List<String> audios = const [],
    List<String> drawings = const [],
  }) {
    final newMemo = Memo(
      title: title,
      content: content,
      imagePaths: images,
      videoPaths: videos,
      audioPaths: audios,
      drawingPaths: drawings,
    );
    _memos.insert(0, newMemo);
    _saveMemos();
    notifyListeners();
  }

  void updateMemo(
    String id,
    String title,
    String content, {
    List<String> images = const [],
    List<String> videos = const [],
    List<String> audios = const [],
    List<String> drawings = const [],
  }) {
    final index = _memos.indexWhere((memo) => memo.id == id);
    if (index != -1) {
      final oldMemo = _memos[index];
      _memos[index] = Memo(
        id: oldMemo.id,
        title: title,
        content: content,
        createdAt: oldMemo.createdAt,
        updatedAt: DateTime.now(), // Update timestamp
        imagePaths: images,
        videoPaths: videos,
        audioPaths: audios,
        drawingPaths: drawings,
      );
      _sortMemos();
      _saveMemos();
      notifyListeners();
    }
  }

  void deleteMemo(String id) {
    _memos.removeWhere((memo) => memo.id == id);
    _saveMemos();
    notifyListeners();
  }
}
