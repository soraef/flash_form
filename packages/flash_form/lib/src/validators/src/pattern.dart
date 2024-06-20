import 'package:flash_form/src/base/src/field_schema.dart';
import 'package:flash_form/src/base/src/field_validator.dart';

class PatternValidatorResult extends ValidatorResult {
  PatternValidatorResult({
    String? message,
  }) : super(
          type: 'pattern',
          message: message ?? 'Invalid pattern',
          value: null,
        );
}

class PatternValidator<TValue, TView> extends FieldValidator<TValue, TView> {
  final RegExp pattern;
  final String? message;

  PatternValidator({required this.pattern, this.message});

  @override
  List<ValidatorResult> validate(FieldSchema<TValue, TView> field) {
    if (field.value is String && !pattern.hasMatch(field.value as String)) {
      return [PatternValidatorResult(message: message)];
    }
    return [];
  }
}
