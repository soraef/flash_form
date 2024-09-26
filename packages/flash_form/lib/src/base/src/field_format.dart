import 'package:flutter/widgets.dart';

import 'field_schema.dart';

abstract class FieldFormat {
  const FieldFormat();

  Widget createFieldWidget(BuildContext context, FieldSchema field);
}

abstract class ValueFieldFormat<TValue, TView> extends FieldFormat {
  ValueFieldFormat();

  TValue? fromView(BuildContext context, TView? value);

  TView? toView(BuildContext context, TValue? value);
}
