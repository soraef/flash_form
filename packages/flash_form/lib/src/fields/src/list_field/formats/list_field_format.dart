import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

import '../widgets/flash_list_field.dart';

class ListFieldFormat<TView, TValue> extends FieldFormat<TView, TValue> {
  const ListFieldFormat();

  @override
  Widget createFieldWidget(BuildContext context, FieldSchema field) {
    return FlashListField(field: field as ListSchema<TView, TValue>);
  }
}
