import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

import '../widgets/flash_list_field.dart';

class ListFieldFormat extends FieldFormat {
  const ListFieldFormat();

  @override
  Widget createFieldWidget(FlashField field) {
    return FlashListField(field: field as ListField);
  }

  @override
  Widget createPreviewWidget(FlashField field) {
    return ListPreviewWidget(
      key: ObjectKey(field),
      field: field as ListField,
    );
  }
}
