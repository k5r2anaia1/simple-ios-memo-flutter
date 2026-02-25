import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Material for some widgets if needed, but trying to stick to Cupertino
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/memo.dart';
import '../services/memo_provider.dart';
import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            const CupertinoSliverNavigationBar(
              largeTitle: Text('메모'),
              trailing: Icon(CupertinoIcons.ellipsis_circle),
            ),
          ];
        },
        body: Consumer<MemoProvider>(
          builder: (context, memoProvider, child) {
            final memos = memoProvider.memos.where((memo) {
              return memo.title.toLowerCase().contains(_searchQuery) ||
                     memo.content.toLowerCase().contains(_searchQuery);
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: CupertinoSearchTextField(
                    controller: _searchController,
                    placeholder: '검색',
                  ),
                ),
                Expanded(
                  child: memos.isEmpty
                      ? const Center(
                          child: Text(
                            '메모가 없습니다.',
                            style: TextStyle(color: CupertinoColors.systemGrey),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: memos.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final memo = memos[index];
                            return _buildMemoCard(context, memo);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (context) => const EditScreen()),
            );
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: CupertinoColors.systemYellow,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey4,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.add,
              color: CupertinoColors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemoCard(BuildContext context, Memo memo) {
    final dateFormat = DateFormat('yyyy. MM. dd.');
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => EditScreen(memo: memo),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              memo.title.isNotEmpty ? memo.title : '제목 없음',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: CupertinoColors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              memo.content.isNotEmpty ? memo.content : '내용 없음',
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemGrey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              dateFormat.format(memo.updatedAt),
              style: const TextStyle(
                fontSize: 12,
                color: CupertinoColors.systemGrey2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
