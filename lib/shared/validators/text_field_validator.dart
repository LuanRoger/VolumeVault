import 'package:volume_vault/shared/validators/int_validators.dart';
import 'package:volume_vault/shared/validators/text_validators.dart';
import 'package:volume_vault/shared/validators/validation_regexes.dart';

String? mandatoryNotEmpty(String? value) {
  String tratedValue = value ?? "";
  if (!StringValidators.notEmpty(tratedValue)) {
    return "Este campo é obrigatório";
  }

  return null;
}

String? mandatoryNotEmptyExactLenght17(String? value) {
  String tratedValue = value ?? "";

  if (!StringValidators.notEmpty(tratedValue)) {
    return "Este campo é obrigatório.";
  }
  if (!StringValidators.exactLenght(tratedValue, lenght: 17)) {
    return "Este campo deve ter exatamente 17 characteres.";
  }

  return null;
}

String? minumumLenght3(String? value) {
  String tratedValue = value ?? "";

  if (!StringValidators.minimumLengh(tratedValue, lenght: 3)) {
    return "Este campo deve conter ao menos 3 characteres.";
  }

  return null;
}

String? minumumLenght8AndMaximum18(String? value) {
  String tratedValue = value ?? "";

  if (!StringValidators.inBetween(tratedValue, min: 8, max: 18)) {
    return "Este campo deve conter mais do que 8 characteres e menos do que 18.";
  }

  return null;
}

String? maximumLenght50(String? value) {
  if (value == null || value.isEmpty) return null;

  if (!StringValidators.maximumLengh(value, lenght: 50)) {
    return "Este campo deve conter menos do que 50 characteres";
  }

  return null;
}

String? maximumLenght100(String? value) {
  if (value == null || value.isEmpty) return null;

  if (!StringValidators.maximumLengh(value, lenght: 100)) {
    return "Este campo deve conter menos do que 100 characteres";
  }

  return null;
}

String? maximumLenght300(String? value) {
  if (value == null || value.isEmpty) return null;

  if (!StringValidators.maximumLengh(value, lenght: 300)) {
    return "Este campo deve conter menos do que 300 characteres";
  }

  return null;
}

String? maximumLenght500(String? value) {
  if (value == null || value.isEmpty) return null;

  if (!StringValidators.maximumLengh(value, lenght: 500)) {
    return "Este campo deve conter menos do que 500 characteres";
  }

  return null;
}

String? greaterThanOrEqualTo1(String? value) {
  if (value == null || value.isEmpty) return null;

  int tratedValue = int.tryParse(value) ?? 0;
  if (!IntValidator.greaterThanOrEqualTo(tratedValue, number: 1)) {
    return "O valor deve ser maior que 0";
  }

  return null;
}

String? matchEmailRegex(String? value) {
  String tratedValue = value ?? "";

  if (!StringValidators.matchWithRegex(tratedValue,
      regex: ValidationRegexes.email)) {
    return "O email digitado não é válido";
  }

  return null;
}
