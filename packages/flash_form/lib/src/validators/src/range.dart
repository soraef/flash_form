import 'package:flash_form/src/base/src/field_schema.dart';
import 'package:flash_form/src/base/src/field_validator.dart';

class RangeValidatorResult extends ValidatorResult {
  RangeValidatorResult({
    String? message,
    super.messageBuilder,
  }) : super(
          type: 'range',
          message: message ?? 'Value is out of range',
          value: null,
        );
}

class RangeValidator<TValue, TView> extends FieldValidator<TValue, TView> {
  final num? min;
  final num? max;
  final String? message;
  final MessageBuilder? messageBuilder;

  RangeValidator(
      {required this.min,
      required this.max,
      this.message,
      this.messageBuilder});

  @override
  List<ValidatorResult> validate(FieldSchema<TValue, TView> field) {
    final value = field.value;
    if (value == null) {
      return [];
    }

    if (min == null || max == null) {
      return [];
    }

    if (min == null && max != null) {
      if (value is num && value > max!) {
        return [
          RangeValidatorResult(message: message, messageBuilder: messageBuilder)
        ];
      }
      return [];
    }

    if (min != null && max == null) {
      if (value is num && value < min!) {
        return [
          RangeValidatorResult(message: message, messageBuilder: messageBuilder)
        ];
      }
      return [];
    }

    if (value is num && (value < min! || value > max!)) {
      return [
        RangeValidatorResult(message: message, messageBuilder: messageBuilder)
      ];
    }
    return [];
  }
}

class ListLengthValidatorResult extends ValidatorResult {
  ListLengthValidatorResult({
    String? message,
    super.messageBuilder,
  }) : super(
          type: 'listLength',
          message: message ?? 'The list length is invalid',
          value: null,
        );
}

class ListLengthValidator<TValue, TView>
    extends FieldValidator<List<TValue>, TView> {
  final int? min;
  final int? max;
  final String? message;
  final MessageBuilder? messageBuilder;

  ListLengthValidator({this.min, this.max, this.message, this.messageBuilder});

  @override
  List<ValidatorResult> validate(FieldSchema<List<TValue>, TView> field) {
    final value = field.value;
    if (value == null) {
      return [];
    }

    if (min == null && max == null) {
      return [];
    }

    if (min == null && max != null) {
      if (value.length > max!) {
        return [
          ListLengthValidatorResult(
            message: message,
            messageBuilder: messageBuilder,
          )
        ];
      }
      return [];
    }

    if (min != null && max == null) {
      if (value.length < min!) {
        return [
          ListLengthValidatorResult(
            message: message,
            messageBuilder: messageBuilder,
          )
        ];
      }
      return [];
    }

    if (value.length < min! || value.length > max!) {
      return [
        ListLengthValidatorResult(
          message: message,
          messageBuilder: messageBuilder,
        )
      ];
    }
    return [];
  }
}
