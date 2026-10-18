
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const CareCartApp());
}

class CareCartApp extends StatelessWidget {
  const CareCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareCart',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF7F0),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
