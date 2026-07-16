import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final fullScreenCase in const [
    _FullScreenCase('iOS', TargetPlatform.iOS, 34),
    _FullScreenCase('Android', TargetPlatform.android, 24),
  ]) {
    testWidgets(
      'all picker wheels respect the ${fullScreenCase.name} full-screen safe area',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(390, 844);
        tester.view.viewPadding = FakeViewPadding(
          bottom: fullScreenCase.bottomInset,
        );
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: fullScreenCase.platform),
            home: Builder(
              builder: (context) => Column(
                children: [
                  _showButton(
                    key: 'single',
                    onPressed: () => Pickers.showSinglePicker(
                      context,
                      data: const ['A', 'B'],
                    ),
                  ),
                  _showButton(
                    key: 'multiple',
                    onPressed: () => Pickers.showMultiPicker(
                      context,
                      data: const [
                        ['A', 'B'],
                        ['1', '2'],
                      ],
                    ),
                  ),
                  _showButton(
                    key: 'linked',
                    onPressed: () => Pickers.showMultiLinkPicker(
                      context,
                      data: const {
                        'A': ['A1', 'A2'],
                        'B': ['B1', 'B2'],
                      },
                      columnNum: 2,
                    ),
                  ),
                  _showButton(
                    key: 'address',
                    onPressed: () => Pickers.showAddressPicker(context),
                  ),
                  _showButton(
                    key: 'date',
                    onPressed: () => Pickers.showDatePicker(context),
                  ),
                ],
              ),
            ),
          ),
        );

        for (final key in ['single', 'multiple', 'linked', 'address', 'date']) {
          await tester.tap(find.byKey(Key(key)));
          await tester.pumpAndSettle();

          final wheelBottom =
              tester.getBottomRight(find.byType(CupertinoPicker).first).dy;
          expect(
            wheelBottom,
            lessThanOrEqualTo(844 - fullScreenCase.bottomInset + 0.01),
            reason: '${fullScreenCase.name}: $key',
          );

          await tester.tapAt(const Offset(10, 10));
          await tester.pumpAndSettle();
          expect(
            tester.takeException(),
            isNull,
            reason: '${fullScreenCase.name}: $key',
          );
        }
      },
    );
  }

  testWidgets('safeArea false allows a picker wheel to reach the screen edge', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.viewPadding = const FakeViewPadding(bottom: 34);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => _showButton(
            key: 'show',
            onPressed: () => Pickers.showSinglePicker(
              context,
              data: const ['A', 'B'],
              pickerStyle: PickerStyle(
                showTitleBar: false,
                safeArea: false,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('show')));
    await tester.pumpAndSettle();

    final wheelBottom =
        tester.getBottomRight(find.byType(CupertinoPicker).first).dy;
    expect(wheelBottom, closeTo(844, 0.01));

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
  });

  testWidgets('editor stays above the keyboard and full-screen safe area', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.viewPadding = const FakeViewPadding(bottom: 34);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => _showButton(
            key: 'editor',
            onPressed: () => Pickers.showMultiPicker(
              context,
              data: const [
                ['A', 'B'],
              ],
              editorHeight: 64,
              editorBuilder: (_, selection, updateSelection) {
                return const SizedBox(
                  key: Key('picker-editor-safe-area'),
                  height: 64,
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('editor')));
    await tester.pumpAndSettle();
    expect(
      tester
          .getBottomRight(find.byKey(const Key('picker-editor-safe-area')))
          .dy,
      closeTo(810, 0.01),
    );

    tester.view.viewInsets = const FakeViewPadding(bottom: 200);
    await tester.pumpAndSettle();
    expect(
      tester
          .getBottomRight(find.byKey(const Key('picker-editor-safe-area')))
          .dy,
      closeTo(610, 0.01),
    );

    await tester.tapAt(const Offset(10, 10));
    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
  });
}

Widget _showButton({required String key, required VoidCallback onPressed}) {
  return TextButton(
    key: Key(key),
    onPressed: onPressed,
    child: Text('Show $key'),
  );
}

class _FullScreenCase {
  const _FullScreenCase(this.name, this.platform, this.bottomInset);

  final String name;
  final TargetPlatform platform;
  final double bottomInset;
}
