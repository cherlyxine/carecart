
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color green = Color(0xFF315747);
  static const Color lightGreen = Color(0xFFE0EBE4);
  static const Color cream = Color(0xFFFAF7F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: Column(
          children: [
            // Top illustration section
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: lightGreen,
                child: Center(
                  child: Container(
                    width: 86,
                    height: 120,
                    decoration: const BoxDecoration(
                      color: cream,
                      border: Border(
                        top: BorderSide(color: green, width: 4),
                        left: BorderSide(color: green, width: 4),
                        right: BorderSide(color: green, width: 4),
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(45),
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shopping_basket_outlined,
                        color: green,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Welcome content
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // CareCart logo and name
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.shopping_basket_outlined,
                              color: Colors.white,
                              size: 19,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'CareCart',
                            style: TextStyle(
                              color: green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // Welcome title
                      const Text(
                        'Welcome to CareCart',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 27,
                          color: Color(0xFF292B28),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Subtitle
                      const Text(
                        'Your care, one simple step at a time.',
                        style: TextStyle(
                          fontSize: 16,
                          color: green,
                        ),
                      ),

                      const SizedBox(height: 26),

                      // Description
                      const Text(
                        'CareCart helps you find, understand and '
                        'complete your healthcare tasks.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF707875),
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Get started button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Let's get started"),
                        ),
                      ),

                      const SizedBox(height: 9),

                      // Helper button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.person_outline),
                          label: const Text('Someone is helping me'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: green,
                            side: const BorderSide(color: green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
