import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/memo_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemoProvider()),
      ],
      child: const SimpleMemoApp(),
    ),
  );
}

class SimpleMemoApp extends StatelessWidget {
  const SimpleMemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Simple Memo',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemYellow,
        scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
