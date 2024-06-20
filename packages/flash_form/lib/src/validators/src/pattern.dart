import 'package:flash_form/src/base/src/flash_field.dart';
import 'package:flash_form/src/base/src/flash_field_validator.dart';

class PatternValidatorResult extends ValidatorResult {
  PatternValidatorResult({
    String? message,
  }) : super(
          type: 'pattern',
          message: message ?? 'Invalid pattern',
          value: null,
        );
}

class PatternValidator<TValue, TView> extends Validator<TValue, TView> {
  final RegExp pattern;
  final String? message;

  PatternValidator({required this.pattern, this.message});

  @override
  List<ValidatorResult> validate(FlashField<TValue, TView> field) {
    if (field.value is String && !pattern.hasMatch(field.value as String)) {
      return [PatternValidatorResult(message: message)];
    }
    return [];
  }
}
