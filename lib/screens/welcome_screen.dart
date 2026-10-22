
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onStart, required this.onHelper});
  final VoidCallback onStart, onHelper;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: Column(children: [
      Expanded(flex: 4, child: Container(width: double.infinity, color: mint, child: Center(child: Container(
        width: 94, height: 130,
        decoration: const BoxDecoration(color: cream, borderRadius: BorderRadius.vertical(top: Radius.circular(50)), border: Border(top: BorderSide(color: forest, width: 4), left: BorderSide(color: forest, width: 4), right: BorderSide(color: forest, width: 4))),
        child: const Center(child: Icon(Icons.shopping_basket_outlined, size: 35, color: forest)),
      )))),
      Expanded(flex: 6, child: ListView(padding: const EdgeInsets.fromLTRB(22, 35, 22, 30), children: [
        const Row(children: [Icon(Icons.shopping_basket_outlined, color: forest), SizedBox(width: 8), Text('CareCart', style: TextStyle(fontSize: 17, color: forest, fontWeight: FontWeight.bold))]),
        const SizedBox(height: 25), const Text('Welcome to CareCart', style: TextStyle(fontSize: 27, fontFamily: 'Georgia')),
        const SizedBox(height: 12), const Text('Your care, one simple step at a time.', style: TextStyle(color: forest, fontSize: 16)),
        const SizedBox(height: 26), const Text('CareCart helps you find, understand and complete your healthcare tasks.', style: TextStyle(height: 1.5, color: Color(0xFF6C756D))),
        const SizedBox(height: 35), SizedBox(height: 49, child: FilledButton(onPressed: onStart, child: const Text("Let's get started"))),
        const SizedBox(height: 9), SizedBox(height: 49, child: OutlinedButton.icon(onPressed: onHelper, icon: const Icon(Icons.person_outline), label: const Text('Someone is helping me'))),
      ])),
    ])),
  );
}
