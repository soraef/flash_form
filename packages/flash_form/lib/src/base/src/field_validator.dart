import 'dart:async';

import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

abstract class FieldValidator<TValue, TView> {
  FutureOr<List<ValidatorResult>> validate(FieldSchema<TValue, TView> field);
}

typedef MessageBuilder = String Function(BuildContext context, String message);

abstract class ValidatorResult {
  final String type;
  final String? message;
  final MessageBuilder? messageBuilder;
  final dynamic value;

  ValidatorResult({
    required this.type,
    this.messageBuilder,
    this.message,
    this.value,
  });

  String? getMessage(BuildContext context) {
    if (messageBuilder != null && message != null) {
      return messageBuilder!(context, message!);
    }
    return message;
  }

  @override
  String toString() {
    return 'ValidatorResult{type: $type, message: $message, value: $value}';
  }
}

extension Validators<TValue, TView> on List<FieldValidator<TValue, TView>> {
  FutureOr<List<ValidatorResult>> validate(
    FieldSchema<TValue, TView> field,
  ) async {
    final results = <ValidatorResult>[];
    for (final validator in this) {
      final result = await validator.validate(field);
      results.addAll(result);
    }
    return results;
  }
}
