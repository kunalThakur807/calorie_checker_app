import 'package:flutter/material.dart';
import 'package:task_app_calorie/scanner_page.dart';

void main() {
  runApp(const CalorieScannerApp());
}

class CalorieScannerApp extends StatelessWidget {
  const CalorieScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScannerPage(),
    );
  }
}
