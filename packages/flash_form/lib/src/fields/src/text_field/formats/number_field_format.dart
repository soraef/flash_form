import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class NumberFieldFormat extends ValueFieldFormat<num, String> {
  final TextFieldParameters? textFieldParams;
  NumberFieldFormat({
    this.textFieldParams,
  });

  @override
  int? fromView(String? value) => int.tryParse(value ?? '');

  @override
  String? toView(num? value) => value?.toString();

  @override
  Widget createFieldWidget(FlashField field) {
    return FlashTextField(
      key: ObjectKey(field),
      field: field as ValueField,
      textFieldParams: textFieldParams,
    );
  }
}
