import 'package:flash_form/flash_form.dart';

class ListContainsValidatorResult extends ValidatorResult {
  ListContainsValidatorResult({
    String? message,
    super.messageBuilder,
  }) : super(
          type: 'listContains',
          message: message ?? 'The list does not contain the required element',
          value: null,
        );
}

class ListContainsValidator<TValue, TView>
    extends FieldValidator<List<TValue>, TView> {
  final TValue requiredElement;
  final String? message;
  final MessageBuilder? messageBuilder;

  ListContainsValidator({
    required this.requiredElement,
    this.message,
    this.messageBuilder,
  });

  @override
  List<ValidatorResult> validate(FieldSchema<List<TValue>, TView> field) {
    if (field.value == null || !field.value!.contains(requiredElement)) {
      return [
        ListContainsValidatorResult(
          message: message,
          messageBuilder: messageBuilder,
        )
      ];
    }
    return [];
  }
}

class ListUniqueValidatorResult extends ValidatorResult {
  ListUniqueValidatorResult({
    String? message,
    super.messageBuilder,
  }) : super(
          type: 'listUnique',
          message: message ?? 'The list contains duplicate elements',
          value: null,
        );
}

class ListUniqueValidator<TValue, TView>
    extends FieldValidator<List<TValue>, TView> {
  final String? message;
  final MessageBuilder? messageBuilder;

  ListUniqueValidator({this.message, this.messageBuilder});

  @override
  List<ValidatorResult> validate(FieldSchema<List<TValue>, TView> field) {
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
