import 'package:flash_form/flash_form.dart';
import 'package:flash_form/src/fields/src/model_field/widgets/flash_model_field.dart';
import 'package:flutter/material.dart';

class ModelFieldFormat extends FieldFormat {
  const ModelFieldFormat();

  @override
  Widget createFieldWidget(FlashField field) {
    return FlashModelField(
      form: field as ObjectField,
    );
  }

  @override
  Widget createPreviewWidget(FlashField field) {
    return FlashPreviewWidget(form: field as ObjectField);
  }
}
