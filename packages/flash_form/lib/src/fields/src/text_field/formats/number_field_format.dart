import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class NumberFieldFormat extends ValueFieldFormat<num, String> {
  final TextFieldParameters? textFieldParams;
  NumberFieldFormat({
    this.textFieldParams,
  });

  @override
  num? fromView(String? value) => num.tryParse(value ?? '');

  @override
  String? toView(num? value) => value?.toString();

  @override
  Widget createFieldWidget(FieldSchema field) {
    return FlashTextField(
      key: ObjectKey(field),
      field: field as ValueSchema,
      textFieldParams: textFieldParams,
    );
  }
}
