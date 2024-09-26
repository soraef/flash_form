import 'package:flutter/widgets.dart';

import 'field_schema.dart';

abstract class FieldFormat<TValue, TView> {
  const FieldFormat();

  Widget createFieldWidget(
      BuildContext context, FieldSchema<TValue, TView> field);
}

abstract class ValueFieldFormat<TValue, TView>
    extends FieldFormat<TValue, TView> {
  ValueFieldFormat();

  TValue? fromView(BuildContext context, TView? value);

  TView? toView(BuildContext context, TValue? value);
}
