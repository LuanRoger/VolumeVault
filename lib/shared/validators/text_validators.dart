class StringValidators {
  static bool notEmpty(String value) => value.isNotEmpty;
  static bool exactLenght(String value, {required int lenght}) =>
      value.length == lenght;
  static bool greaterThanOrEqualTo(String value, {required int number}) =>
      value.length >= number;
  static bool minimumLengh(String value, {required int lenght}) =>
      value.length >= lenght;
  static bool maximumLengh(String value, {required int lenght}) =>
      value.length > lenght;
  static bool inBetween(String value, {required int min, required int max}) =>
      value.length >= min && value.length <= max;
  static bool matchWithRegex(String value, {required String regex}) =>
      RegExp(regex).hasMatch(value);
}
