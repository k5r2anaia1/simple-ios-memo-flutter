import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/memo.dart';

class MemoProvider with ChangeNotifier {
  final String _storageKey = 'simple_memo_app_data';
  List<Memo> _memos = [];
  bool _isLoading = false;

  List<Memo> get memos => _memos;
  bool get isLoading => _isLoading;

  MemoProvider() {
    _loadMemos();
  }

  // Load from SharedPreferences
  Future<void> _loadMemos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);

      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _memos = jsonList.map((e) => Memo.fromJson(e)).toList();
        // Sort by update time (latest first)
        _memos.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      }
    } catch (e) {
      if (kDebugMode) print('Error loading memos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save to SharedPreferences
  Future<void> _saveMemos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(_memos.map((e) => e.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      if (kDebugMode) print('Error saving memos: $e');
    }
  }

  // Add Memo
  void addMemo(String title, String content) {
    if (title.isEmpty && content.isEmpty) return;
    
    final newMemo = Memo(
      id: const Uuid().v4(),
      title: title.isEmpty ? '새로운 메모' : title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _memos.insert(0, newMemo); // Add to top
    _saveMemos();
    notifyListeners();
  }

  // Update Memo
  void updateMemo(String id, String title, String content) {
    final index = _memos.indexWhere((m) => m.id == id);
    if (index != -1) {
      _memos[index] = _memos[index].copyWith(
        title: title.isEmpty ? '제목 없음' : title,
        content: content,
      );
      // Move updated memo to top
      final updatedMemo = _memos.removeAt(index);
      _memos.insert(0, updatedMemo);
      
      _saveMemos();
      notifyListeners();
    }
  }

  // Delete Memo
  void deleteMemo(String id) {
    _memos.removeWhere((m) => m.id == id);
    _saveMemos();
    notifyListeners();
  }
}
