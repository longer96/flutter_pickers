import 'package:flutter/material.dart';
import 'package:flutter_pickers/address_picker/locations_data.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Address Picker keeps addAllItem local to the open picker', (
    tester,
  ) async {
    final original = Address.addAllItem;
    Address.addAllItem = true;
    addTearDown(() => Address.addAllItem = original);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              Pickers.showAddressPicker(context, addAllItem: false);
            },
            child: const Text('Show address picker'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show address picker'));
    await tester.pumpAndSettle();

    expect(Address.addAllItem, isTrue);
    expect(find.text('全部'), findsNothing);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
  });
}
