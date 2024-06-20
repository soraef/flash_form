import 'package:flutter/widgets.dart';

import 'field_schema.dart';

abstract class FieldFormat {
  const FieldFormat();

  Widget createFieldWidget(FieldSchema field);
}

abstract class ValueFieldFormat<TValue, TView> extends FieldFormat {
  ValueFieldFormat();

  TValue? fromView(TView? value);

  TView? toView(TValue? value);
}
