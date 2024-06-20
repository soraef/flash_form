import 'dart:async';

import 'package:flash_form/flash_form.dart';

abstract class Validator<TValue, TView> {
  FutureOr<List<ValidatorResult>> validate(FlashField<TValue, TView> field);
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
  FutureOr<List<ValidatorResult>> validate(
    FlashField<TValue, TView> field,
  ) async {
    final results = <ValidatorResult>[];
    for (final validator in this) {
      final result = await validator.validate(field);
      results.addAll(result);
    }
    return results;
  }
}
