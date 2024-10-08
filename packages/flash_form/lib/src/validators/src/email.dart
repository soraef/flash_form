import 'package:flash_form/src/base/src/field_schema.dart';
import 'package:flash_form/src/base/src/field_validator.dart';

class EmailValidatorResult extends ValidatorResult {
  EmailValidatorResult({
    String? message,
    super.messageBuilder,
  }) : super(
          type: 'email',
          message: message ?? 'Invalid email address',
          value: null,
        );
}

class EmailValidator<TValue, TView> extends FieldValidator<TValue, TView> {
  final String? message;
  final MessageBuilder? messageBuilder;
  final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  EmailValidator({this.message, this.messageBuilder});

  @override
  List<ValidatorResult> validate(FieldSchema<TValue, TView> field) {
    if (field.value is String && !emailRegex.hasMatch(field.value as String)) {
      return [
        EmailValidatorResult(
          message: message,
          messageBuilder: messageBuilder,
        )
      ];
    }
    return [];
  }
}
