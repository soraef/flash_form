import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class NumberFieldFormat extends ValueFieldFormat<num, String> {
  final TextFieldParameters Function(BuildContext context)?
      textFieldParamsFactory;
  NumberFieldFormat({
    this.textFieldParamsFactory,
  });

  @override
  num? fromView(BuildContext context, String? value) =>
      num.tryParse(value ?? '');

  @override
  String? toView(BuildContext context, num? value) => value?.toString();

  @override
  Widget createFieldWidget(BuildContext context, FieldSchema field) {
    final textFieldParams = textFieldParamsFactory?.call(context);
    return FlashTextField(
      key: ObjectKey(field),
      field: field as ValueSchema,
      textFieldParams: textFieldParams,
    );
  }
}
