import 'package:flutter_test/flutter_test.dart';
import 'package:carecart/main.dart';

void main() {
  testWidgets('Welcome and main navigation', (tester) async {
    await tester.pumpWidget(const CareCartApp());
    expect(find.text('Welcome to CareCart'), findsOneWidget);
    await tester.tap(find.text("Let's get started"));
    await tester.pumpAndSettle();
    expect(find.text('Check your blood pressure'), findsOneWidget);
  });
}
