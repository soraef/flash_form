import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class ModelFieldFormat<TValue, TView> extends FieldFormat<TValue, TView> {
  const ModelFieldFormat();

  @override
  Widget createFieldWidget(
    BuildContext context,
    FieldSchema<TValue, TView> field,
  ) {
    return FlashModelField(
      form: field as ModelSchema<TValue>,
    );
  }
}
