import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('multi picker editor and wheels stay synchronized', (
    tester,
  ) async {
    final editorController = TextEditingController();
    final editorFocusNode = FocusNode();
    addTearDown(editorController.dispose);
    addTearDown(editorFocusNode.dispose);
    addTearDown(tester.view.reset);

    List? changedSelection;
    List? confirmedSelection;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  Pickers.showMultiPicker(
                    context,
                    data: [
                      [158, 159, 160, 161, 162, 163],
                      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                    ],
                    selectData: const [160, 1],
                    pickerStyle: PickerStyle(
                      commitButton: const Text(
                        'Confirm',
                        key: Key('confirm-picker'),
                      ),
                    ),
                    editorHeight: 64,
                    editorBuilder: (context, selection, updateSelection) {
                      final value = '${selection[0]}.${selection[1]}';
                      if (editorController.text != value) {
                        editorController.value = TextEditingValue(
                          text: value,
                          selection: TextSelection.collapsed(
                            offset: value.length,
                          ),
                        );
                      }

                      return TextField(
                        key: const Key('picker-editor'),
                        controller: editorController,
                        focusNode: editorFocusNode,
                        onChanged: (value) {
                          final parts = value.split('.');
                          if (parts.length != 2) return;
                          updateSelection([
                            int.tryParse(parts[0]),
                            int.tryParse(parts[1]),
                          ]);
                        },
                      );
                    },
                    onChanged: (selection, positions) {
                      changedSelection = List.of(selection);
                    },
                    onConfirm: (selection, positions) {
                      confirmedSelection = List.of(selection);
                    },
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

    expect(editorController.text, '160.1');

    await tester.drag(
      find.byType(CupertinoPicker).first,
      const Offset(0, -40),
    );
    await tester.pumpAndSettle();

    expect(editorController.text, '161.1');
    expect(changedSelection, [161, 1]);

    await tester.enterText(find.byKey(const Key('picker-editor')), '162.2');
    await tester.pumpAndSettle();

    expect(changedSelection, [162, 2]);
    expect(editorFocusNode.hasFocus, isTrue);

    final editorTopBeforeKeyboard =
        tester.getTopLeft(find.byKey(const Key('picker-editor'))).dy;
    const keyboardInset = 200.0;
    tester.view.viewInsets = FakeViewPadding(
      bottom: keyboardInset * tester.view.devicePixelRatio,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 125));

    final editorTopDuringAnimation =
        tester.getTopLeft(find.byKey(const Key('picker-editor'))).dy;
    expect(editorTopDuringAnimation, lessThan(editorTopBeforeKeyboard));
    expect(
      editorTopDuringAnimation,
      greaterThan(editorTopBeforeKeyboard - keyboardInset),
    );

    await tester.pumpAndSettle();
    final editorTopAboveKeyboard =
        tester.getTopLeft(find.byKey(const Key('picker-editor'))).dy;
    expect(
      editorTopAboveKeyboard,
      closeTo(editorTopBeforeKeyboard - keyboardInset, 0.01),
    );

    await tester.tap(find.byKey(const Key('confirm-picker')));
    await tester.pump();

    expect(confirmedSelection, [162, 2]);
    expect(editorFocusNode.hasFocus, isFalse);

    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
