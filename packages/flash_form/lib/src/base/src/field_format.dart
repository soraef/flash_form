import 'package:flutter/widgets.dart';

import 'field_schema.dart';
import 'flash_field_preview.dart';

abstract class FieldFormat {
  const FieldFormat();

  Widget createFieldWidget(FieldSchema field);
  Widget createPreviewWidget(FieldSchema field) {
    return DefaultPreviewWidget(
      key: UniqueKey(),
      field: field,
    );
  }
}

abstract class ValueFieldFormat<TValue, TView> extends FieldFormat {
  ValueFieldFormat();

  TValue? fromView(TView? value);

  TView? toView(TValue? value);
}
