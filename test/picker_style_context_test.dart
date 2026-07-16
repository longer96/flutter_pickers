import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PickerStyle resolves against each picker context',
      (tester) async {
    final style = PickerStyle();
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            Theme(
              data: ThemeData(primaryColor: Colors.red),
              child: Builder(
                builder: (context) => TextButton(
                  key: const Key('show-red-picker'),
                  onPressed: () {
                    Pickers.showSinglePicker(
                      context,
                      data: const ['Dart', 'Flutter'],
                      pickerStyle: style,
                    );
                  },
                  child: const Text('Show red picker'),
                ),
              ),
            ),
            Theme(
              data: ThemeData(primaryColor: Colors.green),
              child: Builder(
                builder: (context) => TextButton(
                  key: const Key('show-green-picker'),
                  onPressed: () {
                    Pickers.showSinglePicker(
                      context,
                      data: const ['Dart', 'Flutter'],
                      pickerStyle: style,
                    );
                  },
                  child: const Text('Show green picker'),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('show-red-picker')));
    await tester.pumpAndSettle();
    expect(tester.widget<Text>(find.text('确定')).style?.color, Colors.red);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('show-green-picker')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(tester.widget<Text>(find.text('确定')).style?.color, Colors.green);
  });

  testWidgets('PickerStyle is frozen when a picker opens', (tester) async {
    final style = PickerStyle(
      commitButton: const Text('Original', key: Key('original-commit')),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              Pickers.showSinglePicker(
                context,
                data: const ['Dart', 'Flutter'],
                pickerStyle: style,
              );
            },
            child: const Text('Show picker'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show picker'));
    await tester.pump(const Duration(milliseconds: 50));

    style.commitButton = const Text('Changed', key: Key('changed-commit'));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byKey(const Key('original-commit')), findsOneWidget);
    expect(find.byKey(const Key('changed-commit')), findsNothing);

    await tester.tap(find.byKey(const Key('original-commit')));
    await tester.pumpAndSettle();
  });
}
