import 'package:flutter_pickers/src/date_picker/date_selection.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/date_type.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Date Picker clamps leap day when the selected year changes', () {
    final selection = DateSelectionModule(
      mode: DateMode.YMD,
      initial: PDuration(year: 2024, month: 2, day: 29),
      min: PDuration(year: 2023, month: 1, day: 1),
      max: PDuration(year: 2024, month: 12, day: 31),
    );

    final state = selection.select(DateType.year, 0);

    expect(state.selected(DateType.year), 2023);
    expect(state.selected(DateType.month), 2);
    expect(state.selected(DateType.day), 28);
    expect(state.values(DateType.day).last, 28);
  });

  test('Date Picker propagates an hour change into the minute range', () {
    final selection = DateSelectionModule(
      mode: DateMode.HM,
      initial: PDuration(hour: 10, minute: 45),
      min: PDuration(hour: 10, minute: 30),
      max: PDuration(hour: 11, minute: 15),
    );

    final state = selection.select(DateType.hour, 1);

    expect(state.selected(DateType.hour), 11);
    expect(state.values(DateType.minute), List.generate(16, (index) => index));
    expect(state.selected(DateType.minute), 15);
  });

  test('Date Picker propagates a minute change into the second range', () {
    final selection = DateSelectionModule(
      mode: DateMode.HMS,
      initial: PDuration(hour: 10, minute: 30, second: 45),
      min: PDuration(hour: 10, minute: 30, second: 20),
      max: PDuration(hour: 10, minute: 31, second: 10),
    );

    final state = selection.select(DateType.minute, 1);

    expect(state.selected(DateType.minute), 31);
    expect(state.values(DateType.second), List.generate(11, (index) => index));
    expect(state.selected(DateType.second), 10);
  });

  test('Date Picker applies month and day bounds at the selected year', () {
    final selection = DateSelectionModule(
      mode: DateMode.YMD,
      initial: PDuration(year: 2024, month: 6, day: 15),
      min: PDuration(year: 2023, month: 3, day: 10),
      max: PDuration(year: 2024, month: 8, day: 20),
    );

    final state = selection.select(DateType.year, 0);

    expect(
        state.values(DateType.month), List.generate(10, (index) => index + 3));
    expect(state.selected(DateType.month), 6);
    expect(state.values(DateType.day).first, 1);

    final march = selection.select(DateType.month, 0);
    expect(march.selected(DateType.month), 3);
    expect(march.values(DateType.day).first, 10);
    expect(march.selected(DateType.day), 15);
  });

  test('Date Picker does not constrain a day that has no explicit bound', () {
    final selection = DateSelectionModule(
      mode: DateMode.YMD,
      initial: PDuration(year: 2024, month: 1, day: 15),
      min: PDuration(year: 2023),
      max: PDuration(year: 2024, month: 1),
    );

    expect(selection.state.values(DateType.day).last, 31);
    expect(selection.state.selected(DateType.day), 15);
  });

  test('Date Picker state exposes immutable column snapshots', () {
    final selection = DateSelectionModule(
      mode: DateMode.YM,
      initial: PDuration(year: 2024, month: 6),
      min: PDuration(year: 2020),
      max: PDuration(year: 2030),
    );

    expect(
      () => selection.state.values(DateType.month).add(13),
      throwsUnsupportedError,
    );
  });

  const expectedColumnCounts = {
    DateMode.YMDHMS: 6,
    DateMode.YMDHM: 5,
    DateMode.YMDH: 4,
    DateMode.YMD: 3,
    DateMode.YM: 2,
    DateMode.Y: 1,
    DateMode.MDHMS: 5,
    DateMode.MDHM: 4,
    DateMode.MDH: 3,
    DateMode.MD: 2,
    DateMode.HMS: 3,
    DateMode.HM: 2,
    DateMode.MS: 2,
    DateMode.S: 1,
    DateMode.M: 1,
    DateMode.H: 1,
  };

  for (final entry in expectedColumnCounts.entries) {
    test('Date Picker exposes ${entry.value} columns for ${entry.key}', () {
      final selection = DateSelectionModule(
        mode: entry.key,
        initial: PDuration(
          year: 2024,
          month: 6,
          day: 15,
          hour: 12,
          minute: 30,
          second: 30,
        ),
        min: PDuration(year: 2020),
        max: PDuration(year: 2030),
      );

      expect(selection.state.types.length, entry.value);
      for (final type in selection.state.types) {
        expect(selection.state.values(type), isNotEmpty);
      }
    });
  }
}
