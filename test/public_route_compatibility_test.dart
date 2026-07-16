import 'package:flutter/material.dart';
import 'package:flutter_pickers/address_picker/route/address_picker_route.dart';
import 'package:flutter_pickers/more_pickers/route/multiple_link_picker_route.dart';
import 'package:flutter_pickers/more_pickers/route/multiple_picker_route.dart';
import 'package:flutter_pickers/more_pickers/route/single_picker_route.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/route/date_picker_route.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('legacy public picker route constructors remain source compatible', () {
    final style = PickerStyle();
    final theme = ThemeData();
    void onCancel(bool isCancel) {}

    final single = SinglePickerRoute<bool>(
      data: const ['A'],
      selectData: 'A',
      suffix: 'unit',
      pickerStyle: style,
      theme: theme,
      onCancel: onCancel,
      barrierLabel: 'dismiss',
      settings: const RouteSettings(name: 'single'),
    );
    final multiple = MultiplePickerRoute<bool>(
      data: const [
        ['A'],
      ],
      selectData: const ['A'],
      pickerStyle: style,
      theme: theme,
      onCancel: onCancel,
      barrierLabel: 'dismiss',
      settings: const RouteSettings(name: 'multiple'),
    );
    final linked = MultipleLinkPickerRoute<bool>(
      data: const {
        'A': ['A1'],
      },
      selectData: const ['A', 'A1'],
      columnNum: 2,
      pickerStyle: style,
      theme: theme,
      onCancel: onCancel,
      barrierLabel: 'dismiss',
      settings: const RouteSettings(name: 'linked'),
    );
    final address = AddressPickerRoute<bool>(
      addAllItem: true,
      pickerStyle: style,
      initProvince: '',
      initCity: '',
      theme: theme,
      onCancel: onCancel,
      barrierLabel: 'dismiss',
      settings: const RouteSettings(name: 'address'),
    );
    final date = DatePickerRoute<bool>(
      mode: DateMode.YMD,
      initDate: PDuration(year: 2024, month: 1, day: 1),
      minDate: PDuration(year: 2020),
      maxDate: PDuration(year: 2030),
      pickerStyle: style,
      theme: theme,
      onCancel: onCancel,
      barrierLabel: 'dismiss',
      settings: const RouteSettings(name: 'date'),
    );

    final routes = <PopupRoute<bool>>[
      single,
      multiple,
      linked,
      address,
      date,
    ];
    expect(routes, hasLength(5));
    expect(single.theme, same(theme));
    expect(multiple.theme, same(theme));
    expect(linked.pickerStyle, same(style));
    expect(address.onCancel, same(onCancel));
    expect(date.barrierLabel, 'dismiss');
  });
}
