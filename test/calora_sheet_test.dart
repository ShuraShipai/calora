import 'package:calora/core/theme/app_theme.dart';
import 'package:calora/core/widgets/calora_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keeps regular sheets compact', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showCaloraSheet<void>(
                  context: context,
                  showDragHandle: false,
                  builder: (_) => const CaloraSheet(
                    title: 'Add water',
                    child: SizedBox(height: 48),
                  ),
                ),
                child: const Text('Open sheet'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    final sheetHeight = tester.getSize(find.byType(BottomSheet)).height;
    final screenHeight = tester.getSize(find.byType(Scaffold)).height;

    expect(sheetHeight, lessThan(screenHeight / 2));
  });
}
