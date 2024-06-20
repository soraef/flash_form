import 'package:flash_form/src/base/src/field_schema.dart';
import 'package:flash_form/src/base/src/field_validator.dart';

class MinLengthValidatorResult extends ValidatorResult {
  MinLengthValidatorResult({
    String? message,
  }) : super(
          type: 'minLength',
          message: message ?? 'Input is too short',
          value: null,
        );
}

class MinLengthValidator<TValue, TView> extends FieldValidator<TValue, TView> {
  final int minLength;
  final String? message;

  MinLengthValidator({required this.minLength, this.message});

  @override
  List<ValidatorResult> validate(FieldSchema<TValue, TView> field) {
    if (field.value is String && (field.value as String).length < minLength) {
      return [MinLengthValidatorResult(message: message)];
    }
    return [];
  }
}

class MaxLengthValidatorResult extends ValidatorResult {
  MaxLengthValidatorResult({
    String? message,
  }) : super(
          type: 'maxLength',
          message: message ?? 'Input is too long',
          value: null,
        );
}

class MaxLengthValidator<TValue, TView> extends FieldValidator<TValue, TView> {
  final int maxLength;
  final String? message;

  MaxLengthValidator({required this.maxLength, this.message});

  @override
  List<ValidatorResult> validate(FieldSchema<TValue, TView> field) {
    if (field.value is String && (field.value as String).length > maxLength) {
      return [MaxLengthValidatorResult(message: message)];
    }
    return [];
  }
}
