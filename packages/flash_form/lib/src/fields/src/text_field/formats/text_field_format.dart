import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class TextFieldFormat extends ValueFieldFormat<String, String> {
  final TextFieldParameters? textFieldParams;
  TextFieldFormat({
    this.textFieldParams,
  });

  @override
  String? fromView(String? value) => value;

  @override
  String? toView(String? value) => value;

  @override
  Widget createFieldWidget(FlashField field) {
    return FlashTextField(
      key: ObjectKey(field),
      field: field as ValueField,
      textFieldParams: textFieldParams,
    );
  }
}
