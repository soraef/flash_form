import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntFieldFormat extends ValueFieldFormat<int, String> {
  final TextFieldParameters? textFieldParams;
  IntFieldFormat({
    this.textFieldParams,
  });

  static final TextFieldParameters defaultTextFieldParams = TextFieldParameters(
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  );

  @override
  int? fromView(String? value) => int.tryParse(value ?? '');

  @override
  String? toView(int? value) => value?.toString();

  @override
  Widget createFieldWidget(FieldSchema field) {
    return FlashTextField(
      key: ObjectKey(field),
      field: field as ValueSchema,
      textFieldParams: defaultTextFieldParams.merge(textFieldParams),
    );
  }
}
