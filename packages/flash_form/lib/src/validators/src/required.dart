import 'package:flash_form/src/base/src/field_schema.dart';
import 'package:flash_form/src/base/src/field_validator.dart';

class RequiredValidatorResult extends ValidatorResult {
  RequiredValidatorResult({
    String? message,
    super.messageBuilder,
  }) : super(
          type: 'required',
          message: message ?? 'This field is required',
          value: null,
        );
}

class RequiredValidator<TValue, TView> extends FieldValidator<TValue, TView> {
  final String? message;
  final MessageBuilder? messageBuilder;

  RequiredValidator({this.message, this.messageBuilder});

  @override
  List<ValidatorResult> validate(FieldSchema<TValue, TView> field) {
    if (field.value == null) {
      return [
        RequiredValidatorResult(
          message: message,
          messageBuilder: messageBuilder,
        )
      ];
    }

    if (field.value is String) {
      if ((field.value as String).trim().isEmpty) {
        return [RequiredValidatorResult(message: message)];
      }
    }

    if (field.value is List) {
      if ((field.value as List).isEmpty) {
        return [RequiredValidatorResult(message: message)];
      }
    }
    return [];
  }
}
