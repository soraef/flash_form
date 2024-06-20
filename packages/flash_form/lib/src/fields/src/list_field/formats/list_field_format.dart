import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

import '../widgets/flash_list_field.dart';

class ListFieldFormat extends FieldFormat {
  const ListFieldFormat();

  @override
  Widget createFieldWidget(FieldSchema field) {
    return FlashListField(field: field as ListSchema);
  }
}
