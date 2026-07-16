import 'package:flutter_pickers/address_picker/locations_data.dart';
import 'package:flutter_pickers/src/cascading_picker/cascading_selection.dart';

class AddressAdapter implements CascadingDataAdapter {
  AddressAdapter({
    required this.allText,
    required this.addAllItem,
    required this.hasTown,
  });

  final String allText;
  final bool addAllItem;
  final bool hasTown;

  @override
  int get columnCount => hasTown ? 3 : 2;

  @override
  List valuesFor(int column, List selection) {
    switch (column) {
      case 0:
        return List<String>.from(Address.provinces);
      case 1:
        return _cities(selection[0] as String);
      case 2:
        return _towns(
          selection[0] as String,
          selection[1] as String,
        );
      default:
        throw RangeError.range(column, 0, columnCount - 1, 'column');
    }
  }

  List<String> _cities(String province) {
    final provinceCode = _provinceCode(province);
    final names = locations[provinceCode]?.values.toList() ?? <String>[];
    if (addAllItem) names.insert(0, allText);
    return names.isEmpty ? [allText] : names;
  }

  List<String> _towns(String province, String city) {
    if (addAllItem && city == allText) return [allText];

    final provinceCode = _provinceCode(province);
    var cityCode = '';
    locations[provinceCode]?.forEach((code, name) {
      if (name == city) cityCode = code;
    });
    if (cityCode.isEmpty) return [allText];

    final names = locations[cityCode]?.values.toList() ?? <String>[];
    if (names.isEmpty) return [allText];
    if (addAllItem) names.insert(0, allText);
    return names;
  }

  String _provinceCode(String province) {
    var code = '';
    locations['86']?.forEach((candidate, name) {
      if (name == province) code = candidate;
    });
    return code;
  }
}
