import 'package:flutter/material.dart';
import 'dart:io';
import '../models/care_models.dart';
import '../theme/app_colors.dart';
import '../screens/welcome_screen.dart';
import '../screens/add_medicine_screen.dart';

part '../widgets/common_widgets.dart';
part '../screens/today_screen.dart';
part '../screens/guidance_screen.dart';
part '../screens/reading_screen.dart';
part '../screens/finished_screen.dart';
part '../screens/basket_screen.dart';
part '../screens/aisles_screen.dart';
part '../screens/health_screen.dart';
part '../screens/medicines_screen.dart';
part '../screens/appointments_screen.dart';
part '../screens/help_screen.dart';
part '../screens/profile_screen.dart';
part '../screens/accessibility_screen.dart';
part 'dialogs.dart';

class CareCartRoot extends StatefulWidget {
  const CareCartRoot({super.key});
  @override
  State<CareCartRoot> createState() => _CareCartRootState();
}

class _CareCartRootState extends State<CareCartRoot> {
  bool started = false;
  int tab = 0;
  String page = '';
  final List<Medicine> medicines = [
    Medicine('Amlodipine', '5 mg · 1 tablet', '8:00 in the morning', 'Follow your care team instructions'),
    Medicine('Vitamin D', '10 micrograms · 1 tablet', '8:00 in the morning', 'Take with breakfast'),
    Medicine('Atorvastatin', '1 tablet', 'Evening', 'Follow your care team instructions'),
  ];
  final List<Appointment> appointments = [
    Appointment('GP appointment', '15 May', '10:30', 'Rosewood Medical Centre', 'Dr. Helen Morris'),
  ];
  final List<String> tasks = ['Check blood pressure', 'Take morning medicine', 'Prepare for GP appointment', 'Drink enough water'];
  final Set<int> completed = {};
  final List<String> notes = ['Mention that I sometimes feel tired in the afternoon.'];
  final Map<String, bool> accessibility = {
    'Larger text': false,
    'Read aloud': false,
    'Higher contrast': false,
    'Slow down animations': false,
    'Stronger notifications': false,
  };
  String name = 'Anna Wilson';
  bool measured = false;
  String systolic = '128', diastolic = '78';

  void open(String target) => setState(() => page = target);
  void goTab(int value) => setState(() { tab = value; page = ''; });
  void back() => setState(() => page = '');

  @override
  Widget build(BuildContext context) {
    final scale = accessibility['Larger text']! ? 1.13 : 1.0;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
      child: !started
          ? WelcomeScreen(onStart: () => setState(() => started = true), onHelper: () { setState(() { started = true; tab = 3; }); })
          : Scaffold(
              appBar: AppBar(
                backgroundColor: cream,
                leading: page.isNotEmpty ? IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: back) : null,
                title: page.isEmpty ? const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.shopping_basket_outlined, size: 19), SizedBox(width: 8), Text('CareCart', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600))]) : const SizedBox.shrink(),
                actions: [
                  TextButton.icon(onPressed: () => open('accessibility'), icon: const Icon(Icons.auto_awesome, size: 15), label: const Text('Make it easier')),
                  IconButton(onPressed: () => open('profile'), icon: const Icon(Icons.person_outline)),
                ],
              ),
              body: SafeArea(child: _body()),
              bottomNavigationBar: NavigationBar(
                height: 70,
                selectedIndex: tab,
                onDestinationSelected: goTab,
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Today'),
                  NavigationDestination(icon: Icon(Icons.shopping_basket_outlined), label: 'Basket'),
                  NavigationDestination(icon: Icon(Icons.table_restaurant_outlined), label: 'Aisles'),
                  NavigationDestination(icon: Icon(Icons.headset_mic_outlined), label: 'Help'),
                ],
              ),
            ),
    );
  }

  void _update(VoidCallback change) => setState(change);

  Widget _body() {
    switch (page) {
      case 'profile': return _profile();
      case 'accessibility': return _accessibility();
      case 'health': return _health();
      case 'medicines': return _medicines();
      case 'appointments': return _appointments();
      case 'reading': return _reading();
      case 'finished': return _finished();
      case 'guidance': return _guidance();
      default:
        return [ _today(), _basket(), _aisles(), _help() ][tab];
    }
  }

}
