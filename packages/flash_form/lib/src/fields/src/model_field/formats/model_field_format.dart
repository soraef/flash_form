import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class ModelFieldFormat extends FieldFormat {
  const ModelFieldFormat();

  @override
  Widget createFieldWidget(FieldSchema field) {
    return FlashModelField(
      form: field as ModelSchema,
    );
  }

  @override
  Widget createPreviewWidget(FieldSchema field) {
    return FlashPreviewWidget(form: field as ModelSchema);
  }
}
