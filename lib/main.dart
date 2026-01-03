import 'package:flutter/material.dart';
import 'screens/emoji_feedback_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6A7BD8),
        brightness: Brightness.light,
      ),
      home: const EmojiFeedbackScreen(),
    );
  }
}
