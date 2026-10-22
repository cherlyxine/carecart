import 'package:flutter/material.dart';
import 'app/carecart_root.dart';
import 'theme/app_colors.dart';

void main() => runApp(const CareCartApp());

class CareCartApp extends StatelessWidget {
  const CareCartApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CareCart',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(seedColor: forest, primary: forest, surface: cream),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cream,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    ),
    home: const CareCartRoot(),
  );
}
