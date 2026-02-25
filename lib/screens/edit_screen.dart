import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/memo.dart';
import '../services/memo_provider.dart';

class EditScreen extends StatefulWidget {
  final Memo? memo;

  const EditScreen({Key? key, this.memo}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _contentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.memo != null) {
      _titleController.text = widget.memo!.title;
      _contentController.text = widget.memo!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  void _saveMemo() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty && content.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    if (widget.memo == null) {
      // Add new
      Provider.of<MemoProvider>(context, listen: false).addMemo(title, content);
    } else {
      // Update
      Provider.of<MemoProvider>(context, listen: false).updateMemo(
        widget.memo!.id,
        title,
        content,
      );
    }
    Navigator.of(context).pop();
  }

  void _deleteMemo() {
    if (widget.memo != null) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('메모 삭제'),
          content: const Text('이 메모를 삭제하시겠습니까?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('취소'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('삭제'),
              onPressed: () {
                Provider.of<MemoProvider>(context, listen: false)
                    .deleteMemo(widget.memo!.id);
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close screen
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.memo == null ? '새 메모' : '메모 편집'),
        trailing: widget.memo != null
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _deleteMemo,
                child: const Icon(CupertinoIcons.trash),
              )
            : null,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CupertinoTextField(
                controller: _titleController,
                placeholder: '제목',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: null, // Remove border
                maxLength: 50,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: CupertinoTextField(
                  controller: _contentController,
                  focusNode: _contentFocus,
                  placeholder: '내용을 입력하세요...',
                  style: const TextStyle(fontSize: 16),
                  decoration: null, // Remove border
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ),
            // Bottom toolbar
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: CupertinoColors.separator)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton.filled(
                    onPressed: _saveMemo,
                    child: const Text('완료'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
