import 'dart:collection';

import 'package:flutter_pickers/time_picker/model/date_item_model.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/date_type.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/time_utils.dart';

/// Pure Date Picker state. It owns range propagation and selected positions,
/// while the Flutter route adapter owns wheel controllers and rendering.
class DateSelectionModule {
  DateSelectionModule({
    required DateMode mode,
    required PDuration initial,
    required PDuration min,
    required PDuration max,
  })  : _visibleTypes = _typesFor(mode),
        _initial = _DateValues.fromDuration(initial),
        _min = _DateValues.fromDuration(min),
        _max = _DateValues.fromDuration(max) {
    _state = _derive(_initial, clampInvalidValues: false);
  }

  final List<DateType> _visibleTypes;
  final _DateValues _initial;
  final _DateValues _min;
  final _DateValues _max;
  late DateSelectionState _state;

  DateSelectionState get state => _state;

  DateSelectionState select(DateType type, int index) {
    final values = _state.values(type);
    if (index < 0 || index >= values.length) {
      throw RangeError.index(index, values, 'index');
    }

    final desired = _DateValues.fromState(_state).withValue(
      type,
      values[index],
    );
    _state = _derive(desired, clampInvalidValues: true);
    return _state;
  }

  DateSelectionState _derive(
    _DateValues desired, {
    required bool clampInvalidValues,
  }) {
    final columns = <DateType, List<int>>{};
    var selected = const _DateValues();

    for (final type in _visibleTypes) {
      final values = _valuesFor(type, selected);
      if (values.isEmpty) {
        throw StateError('Date Picker has no values for $type');
      }

      final desiredValue = desired.value(type);
      final value = values.contains(desiredValue)
          ? desiredValue!
          : _fallbackValue(values, desiredValue, clampInvalidValues);
      columns[type] = values;
      selected = selected.withValue(type, value);
    }

    return DateSelectionState._(columns, selected);
  }

  int _fallbackValue(List<int> values, int? desired, bool clamp) {
    if (clamp && desired != null && desired > values.last) {
      return values.last;
    }
    return values.first;
  }

  List<int> _valuesFor(DateType type, _DateValues selected) {
    switch (type) {
      case DateType.year:
        return _ints(
          TimeUtils.calcYears(
            begin: _min.year.nonZeroOr(1900),
            end: _max.year.nonZeroOr(2100),
          ),
        );
      case DateType.month:
        var begin = 1;
        var end = 12;
        if (_visibleTypes.contains(DateType.year)) {
          if (_min.month.isNotEmpty && selected.year == _min.year) {
            begin = _min.month!;
          }
          if (_max.month.isNotEmpty && selected.year == _max.year) {
            end = _max.month!;
          }
        }
        return _ints(TimeUtils.calcMonth(begin: begin, end: end));
      case DateType.day:
        var begin = 1;
        var end = 31;
        if (_visibleTypes.contains(DateType.year) &&
            selected.year == _min.year &&
            selected.month == _min.month &&
            _min.day.isNotEmpty) {
          begin = _min.day!;
        }
        if (_visibleTypes.contains(DateType.year) &&
            selected.year == _max.year &&
            selected.month == _max.month &&
            _max.day.isNotEmpty) {
          end = _max.day!;
        }
        return _ints(
          TimeUtils.calcDay(
            selected.year ?? _initial.year.nonZeroOr(DateTime.now().year),
            selected.month ?? _initial.month.nonZeroOr(1),
            begin: begin,
            end: end,
          ),
        );
      case DateType.hour:
        return _ints(
          TimeUtils.calcHour(
            begin: _min.hour.nonZeroOr(0),
            end: _max.hour.nonZeroOr(23),
          ),
        );
      case DateType.minute:
        var begin = 0;
        var end = 59;
        if (_min.minute.isNotEmpty || _max.minute.isNotEmpty) {
          if (_visibleTypes.contains(DateType.hour)) {
            if (selected.hour == _min.hour) begin = _min.minute ?? 0;
            if (selected.hour == _max.hour) end = _max.minute ?? 59;
          } else {
            begin = _min.minute.nonZeroOr(0);
            end = _max.minute.nonZeroOr(59);
          }
        }
        return _ints(TimeUtils.calcMinAndSecond(begin: begin, end: end));
      case DateType.second:
        var begin = 0;
        var end = 59;
        if (_min.second.isNotEmpty || _max.second.isNotEmpty) {
          final hasHour = _visibleTypes.contains(DateType.hour);
          final hasMinute = _visibleTypes.contains(DateType.minute);
          if (hasHour && hasMinute) {
            if (selected.hour == _min.hour && selected.minute == _min.minute) {
              begin = _min.second ?? 0;
            }
            if (selected.hour == _max.hour && selected.minute == _max.minute) {
              end = _max.second ?? 59;
            }
          } else if (hasMinute) {
            if (selected.minute == _min.minute) begin = _min.second ?? 0;
            if (selected.minute == _max.minute) end = _max.second ?? 59;
          } else {
            begin = _min.second.nonZeroOr(0);
            end = _max.second.nonZeroOr(59);
          }
        }
        return _ints(TimeUtils.calcMinAndSecond(begin: begin, end: end));
    }
  }

  static List<DateType> _typesFor(DateMode mode) {
    final items = DateItemModel.parse(mode);
    return [
      if (items.year) DateType.year,
      if (items.month) DateType.month,
      if (items.day) DateType.day,
      if (items.hour) DateType.hour,
      if (items.minute) DateType.minute,
      if (items.second) DateType.second,
    ];
  }

  static List<int> _ints(List values) => values.cast<int>();
}

class DateSelectionState {
  DateSelectionState._(
    Map<DateType, List<int>> columns,
    _DateValues selected,
  )   : _columns = Map.unmodifiable(
          columns.map(
            (type, values) => MapEntry(
              type,
              UnmodifiableListView<int>(List<int>.from(values)),
            ),
          ),
        ),
        _selected = selected;

  final Map<DateType, List<int>> _columns;
  final _DateValues _selected;

  Iterable<DateType> get types => _columns.keys;

  List<int> values(DateType type) => _columns[type] ?? const [];

  int? selected(DateType type) => _selected.value(type);

  int position(DateType type) => values(type).indexOf(selected(type)!);

  PDuration toDuration() {
    return PDuration(
      year: _selected.year ?? 0,
      month: _selected.month ?? 0,
      day: _selected.day ?? 0,
      hour: _selected.hour ?? 0,
      minute: _selected.minute ?? 0,
      second: _selected.second ?? 0,
    );
  }
}

class _DateValues {
  const _DateValues({
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
  });

  factory _DateValues.fromDuration(PDuration duration) {
    return _DateValues(
      year: duration.year,
      month: duration.month,
      day: duration.day,
      hour: duration.hour,
      minute: duration.minute,
      second: duration.second,
    );
  }

  factory _DateValues.fromState(DateSelectionState state) => state._selected;

  final int? year;
  final int? month;
  final int? day;
  final int? hour;
  final int? minute;
  final int? second;

  int? value(DateType type) {
    switch (type) {
      case DateType.year:
        return year;
      case DateType.month:
        return month;
      case DateType.day:
        return day;
      case DateType.hour:
        return hour;
      case DateType.minute:
        return minute;
      case DateType.second:
        return second;
    }
  }

  _DateValues withValue(DateType type, int value) {
    return _DateValues(
      year: type == DateType.year ? value : year,
      month: type == DateType.month ? value : month,
      day: type == DateType.day ? value : day,
      hour: type == DateType.hour ? value : hour,
      minute: type == DateType.minute ? value : minute,
      second: type == DateType.second ? value : second,
    );
  }
}

extension on int? {
  bool get isNotEmpty => this != null && this != 0;

  int nonZeroOr(int fallback) => isNotEmpty ? this! : fallback;
}
