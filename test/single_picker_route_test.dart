import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('single picker route can be dismissed without dispose errors', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  Pickers.showSinglePicker(
                    context,
                    data: const ['Dart', 'Flutter'],
                  );
                },
                child: const Text('Show picker'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show picker'));
    await tester.pumpAndSettle();

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
