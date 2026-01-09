/// 工具类：提供常用的空值检查方法
class PicketUtil {
  // 私有构造函数，防止实例化
  PicketUtil._();

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

  /// Map 不为空
  static bool mapNoEmpty(Map? value) {
    if (value == null) return false;
    return value.isNotEmpty;
  }

  /// Map 为空
  static bool mapEmpty(Map? value) {
    if (value == null) return true;
    return value.isEmpty;
  }

  /// 判断 List 不为空（修复了原来的逻辑错误）
  static bool listNoEmpty(List? list) {
    if (list == null) return false;
    return list.isNotEmpty;
  }

  /// 判断 List 为空
  static bool listEmpty(List? list) {
    if (list == null) return true;
    return list.isEmpty;
  }
}
