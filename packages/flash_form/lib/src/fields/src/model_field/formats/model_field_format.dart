import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class ModelFieldFormat extends FieldFormat {
  const ModelFieldFormat();

  @override
  Widget createFieldWidget(BuildContext context, FieldSchema field) {
    return FlashModelField(
      form: field as ModelSchema,
    );
  }
}
