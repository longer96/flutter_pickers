class PicketUtil {
  /// 字符串不为空
  static bool strNoEmpty(String? value) {
    if (value == null) return false;

    return value.trim().isNotEmpty;
  }

  /// 字符串为空
  static bool strEmpty(String? value) {
    if (value == null) return true;

    return value.trim().isEmpty;
  }

  /// MAp不为空
  static bool mapNoEmpty(Map? value) {
    if (value == null) return false;
    return value.isNotEmpty;
  }

  /// MAp为空
  static bool mapEmpty(Map? value) {
    if (value == null) return true;
    return value.isEmpty;
  }

  ///判断List是否为空
  static bool listNoEmpty(List? list) {
    if (list == null) return false;

    if (list.length == 0) return false;

    return true;
  }

  ///判断List是否为空
  static bool listEmpty(List? list) {
    if (list == null) return true;

    if (list.length == 0) return true;

    return false;
  }
}
