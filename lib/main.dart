import 'package:flutter/material.dart';
import 'screens/language_screen.dart';

void main() {
  runApp(const MedAlertApp());
}

class MedAlertApp extends StatelessWidget {
  const MedAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vision-Verified Med Alert',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const LanguageScreen(),
    );
  }
}