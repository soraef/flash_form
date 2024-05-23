import 'package:flash_form/flash_form.dart';

abstract class Validator<TValue, TView> {
  List<ValidatorResult> validate(FlashField<TValue, TView> field);
}

abstract class ValidatorResult {
  final String type;
  final String? message;
  final dynamic value;

  ValidatorResult({
    required this.type,
    this.message,
    this.value,
  });

  @override
  String toString() {
    return 'ValidatorResult{type: $type, message: $message, value: $value}';
  }
}

extension Validators<TValue, TView> on List<Validator<TValue, TView>> {
  List<ValidatorResult> validate(FlashField<TValue, TView> field) {
    return expand((validator) => validator.validate(field)).toList();
  }
}

class RequiredValidatorResult extends ValidatorResult {
  RequiredValidatorResult({
    String? message,
  }) : super(
          type: 'required',
          message: message ?? 'This field is required',
          value: null,
        );
}

class RequiredValidator<TValue, TView> extends Validator<TValue, TView> {
  final String? message;

  RequiredValidator({this.message});

  @override
  List<ValidatorResult> validate(FlashField<TValue, TView> field) {
    if (field.value == null) {
      return [RequiredValidatorResult(message: message)];
    }

    if (field.value is String) {
      if ((field.value as String).trim().isEmpty) {
        return [RequiredValidatorResult(message: message)];
      }
    }
    return [];
  }
}
