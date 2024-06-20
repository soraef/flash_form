import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class TypeFieldFormat<TValue, TView, TOption> extends FieldFormat {
  const TypeFieldFormat();

  @override
  Widget createFieldWidget(FieldSchema field) {
    return FlashTypeField<TValue, TView, TOption>(
      key: ObjectKey(field),
      field: field as TypeSchema<TValue, TView, TOption>,
    );
  }
}
