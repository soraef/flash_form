import 'package:flash_form/src/fields/src/type_field/widgets/flash_type_field.dart';
import 'package:flutter/widgets.dart';

import 'flash_field.dart';
import 'flash_field_preview.dart';
import 'flash_field_widget.dart';

abstract class FieldFormat {
  const FieldFormat();

  Widget createFieldWidget(FlashField field);
  Widget createPreviewWidget(FlashField field) {
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
