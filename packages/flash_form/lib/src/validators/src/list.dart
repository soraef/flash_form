import 'package:flash_form/flash_form.dart';

class ListContainsValidatorResult extends ValidatorResult {
  ListContainsValidatorResult({
    String? message,
  }) : super(
          type: 'listContains',
          message: message ?? 'The list does not contain the required element',
          value: null,
        );
}

class ListContainsValidator<TValue, TView>
    extends Validator<List<TValue>, TView> {
  final TValue requiredElement;
  final String? message;

  ListContainsValidator({required this.requiredElement, this.message});

  @override
  List<ValidatorResult> validate(FlashField<List<TValue>, TView> field) {
    if (field.value == null || !field.value!.contains(requiredElement)) {
      return [ListContainsValidatorResult(message: message)];
    }
    return [];
  }
}

class ListUniqueValidatorResult extends ValidatorResult {
  ListUniqueValidatorResult({
    String? message,
  }) : super(
          type: 'listUnique',
          message: message ?? 'The list contains duplicate elements',
          value: null,
        );
}

class ListUniqueValidator<TValue, TView>
    extends Validator<List<TValue>, TView> {
  final String? message;

  ListUniqueValidator({this.message});

  @override
  List<ValidatorResult> validate(FlashField<List<TValue>, TView> field) {
    if (field.value == null) {
      return [];
    }

    final Set<TValue> uniqueElements = Set.from(field.value!);
    if (uniqueElements.length != field.value!.length) {
      return [ListUniqueValidatorResult(message: message)];
    }
    return [];
  }
}
