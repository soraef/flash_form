import 'package:flash_form/src/base/src/field_schema.dart';
import 'package:flash_form/src/base/src/field_validator.dart';

class EmailValidatorResult extends ValidatorResult {
  EmailValidatorResult({
    String? message,
  }) : super(
          type: 'email',
          message: message ?? 'Invalid email address',
          value: null,
        );
}

class EmailValidator<TValue, TView> extends FieldValidator<TValue, TView> {
  final String? message;
  final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  EmailValidator({this.message});

  @override
  List<ValidatorResult> validate(FieldSchema<TValue, TView> field) {
    if (field.value is String && !emailRegex.hasMatch(field.value as String)) {
      return [EmailValidatorResult(message: message)];
    }
    return [];
  }
}
