import 'package:volume_vault/shared/validators/int_validators.dart';
import 'package:volume_vault/shared/validators/text_validators.dart';

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

String? maximumLenght50(String? value) {
  if (value == null || value.isEmpty) return null;

  if (!StringValidators.maximumLengh(value, lenght: 50)) {
    return "Este campo deve conter menos do que 50 characteres";
  }

  return null;
}

String? maximumLenght100(String? value) {
  if (value == null || value.isEmpty) return null;

  if (StringValidators.maximumLengh(value, lenght: 100)) {
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
