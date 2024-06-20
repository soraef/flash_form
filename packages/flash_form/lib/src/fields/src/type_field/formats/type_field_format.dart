import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

import '../widgets/flash_type_field.dart';

class TypeFieldFormat<TValue, TView, TOption> extends FieldFormat {
  const TypeFieldFormat();

  @override
  Widget createFieldWidget(FlashField field) {
    return FlashTypeField<TValue, TView, TOption>(
      key: ObjectKey(field),
      field: field as TypeField<TValue, TView, TOption>,
    );
  }

  @override
  Widget createPreviewWidget(FlashField field) {
    return TypePreviewWidget(
      field: field as TypeField,
    );
  }
}
