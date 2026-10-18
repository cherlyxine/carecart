
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carecart/main.dart';

void main() {
  testWidgets('CareCart welcome screen test', (tester) async {
    await tester.pumpWidget(const CareCartApp());

    expect(find.text('Welcome to CareCart'), findsOneWidget);
    expect(find.text("Let's get started"), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
