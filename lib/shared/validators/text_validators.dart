class StringValidators {
  static bool notEmpty(String value) => value.isNotEmpty;
  static bool exactLenght(String value, {required int lenght}) =>
      value.length == lenght;
  static bool greaterThanOrEqualTo(String value, {required int number}) =>
      value.length >= number;
  static bool maximumLengh(String value, {required int lenght}) =>
      value.length > lenght;
}
