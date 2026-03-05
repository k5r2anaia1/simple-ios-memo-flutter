import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

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

  List<String> _imagePaths = [];
  List<String> _videoPaths = [];
  List<String> _audioPaths = [];
  List<String> _drawingPaths = [];

  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    if (widget.memo != null) {
      _titleController.text = widget.memo!.title;
      _contentController.text = widget.memo!.content;
      _imagePaths = List.from(widget.memo!.imagePaths);
      _videoPaths = List.from(widget.memo!.videoPaths);
      _audioPaths = List.from(widget.memo!.audioPaths);
      _drawingPaths = List.from(widget.memo!.drawingPaths);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocus.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _imagePaths.add(image.path);
      });
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    final XFile? video = await _picker.pickVideo(source: source);
    if (video != null) {
      setState(() {
        _videoPaths.add(video.path);
      });
    }
  }

  Future<void> _recordAudio() async {
    if (await _audioRecorder.hasPermission()) {
      if (!_isRecording) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/${const Uuid().v4()}.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() {
          _isRecording = true;
        });
      } else {
        final path = await _audioRecorder.stop();
        if (path != null) {
          setState(() {
            _audioPaths.add(path);
            _isRecording = false;
          });
        }
      }
    }
  }

  Future<void> _openDrawingPad() async {
    final SignatureController _controller = SignatureController(
      penStrokeWidth: 3,
      penColor: CupertinoColors.black,
      exportBackgroundColor: CupertinoColors.white,
    );

    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 500,
        color: CupertinoColors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('취소'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text('서명/그리기', style: TextStyle(fontWeight: FontWeight.bold)),
                  CupertinoButton(
                    child: const Text('저장'),
                    onPressed: () async {
                      if (_controller.isNotEmpty) {
                        final Uint8List? data = await _controller.toPngBytes();
                        if (data != null) {
                          final directory = await getApplicationDocumentsDirectory();
                          final path = '${directory.path}/drawing_${const Uuid().v4()}.png';
                          File(path).writeAsBytesSync(data);
                          setState(() {
                            _drawingPaths.add(path);
                          });
                        }
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Signature(
                controller: _controller,
                backgroundColor: CupertinoColors.systemGrey6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                child: const Text('지우기', style: TextStyle(color: CupertinoColors.destructiveRed)),
                onPressed: () => _controller.clear(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveMemo() {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty && content.isEmpty && _imagePaths.isEmpty && _drawingPaths.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    if (widget.memo == null) {
      Provider.of<MemoProvider>(context, listen: false).addMemo(
        title,
        content,
        images: _imagePaths,
        videos: _videoPaths,
        audios: _audioPaths,
        drawings: _drawingPaths,
      );
    } else {
      Provider.of<MemoProvider>(context, listen: false).updateMemo(
        widget.memo!.id,
        title,
        content,
        images: _imagePaths,
        videos: _videoPaths,
        audios: _audioPaths,
        drawings: _drawingPaths,
      );
    }
    Navigator.of(context).pop();
  }

  void _deleteMemo() {
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
              Navigator.of(context).pop(); 
              Navigator.of(context).pop(); 
            },
          ),
        ],
      ),
    );
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
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: null,
                maxLength: 50,
              ),
            ),
            Container(height: 1, color: CupertinoColors.separator),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: CupertinoTextField(
                        controller: _contentController,
                        focusNode: _contentFocus,
                        placeholder: '내용을 입력하세요...',
                        style: const TextStyle(fontSize: 16),
                        decoration: null,
                        maxLines: null,
                        scrollPhysics: const NeverScrollableScrollPhysics(), // Let SingleChildScrollView handle scrolling
                      ),
                    ),
                    // Attachments Grid
                    if (_imagePaths.isNotEmpty || _drawingPaths.isNotEmpty)
                      _buildImageGrid(),
                    if (_videoPaths.isNotEmpty)
                      _buildVideoList(),
                    if (_audioPaths.isNotEmpty)
                      _buildAudioList(),
                  ],
                ),
              ),
            ),
            _buildToolbar(),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: CupertinoColors.separator)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.camera),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              const SizedBox(width: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.photo),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              const SizedBox(width: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.video_camera),
                onPressed: () => _pickVideo(ImageSource.camera),
              ),
              const SizedBox(width: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  _isRecording ? CupertinoIcons.stop_circle_fill : CupertinoIcons.mic,
                  color: _isRecording ? CupertinoColors.destructiveRed : CupertinoColors.activeBlue,
                ),
                onPressed: _recordAudio,
              ),
              const SizedBox(width: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Icon(CupertinoIcons.pencil_outline),
                onPressed: _openDrawingPad,
              ),
            ],
          ),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            onPressed: _saveMemo,
            child: const Text('완료'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    final allImages = [..._imagePaths, ..._drawingPaths];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: allImages.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Image.file(File(allImages[index]), fit: BoxFit.cover, width: double.infinity, height: double.infinity),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_imagePaths.contains(allImages[index])) {
                      _imagePaths.remove(allImages[index]);
                    } else {
                      _drawingPaths.remove(allImages[index]);
                    }
                  });
                },
                child: const Icon(CupertinoIcons.xmark_circle_fill, color: CupertinoColors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVideoList() {
    return Column(
      children: _videoPaths.map((path) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(CupertinoIcons.film),
            const SizedBox(width: 8),
            Expanded(child: Text(path.split('/').last)),
            CupertinoButton(
              child: const Icon(CupertinoIcons.play_circle),
              onPressed: () {
                // Play video logic (omitted for brevity, ideally open a player dialog)
              },
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildAudioList() {
    return Column(
      children: _audioPaths.map((path) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(CupertinoIcons.waveform),
            const SizedBox(width: 8),
            Expanded(child: Text('Voice Memo ${path.split('/').last.substring(0, 5)}...')),
            CupertinoButton(
              child: const Icon(CupertinoIcons.play_circle),
              onPressed: () async {
                await _audioPlayer.play(DeviceFileSource(path));
              },
            ),
          ],
        ),
      )).toList(),
    );
  }
}
