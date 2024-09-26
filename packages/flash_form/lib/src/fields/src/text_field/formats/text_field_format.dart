import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class TextFieldFormat extends ValueFieldFormat<String, String> {
  final TextFieldParameters Function(BuildContext context)?
      textFieldParamsFactory;
  TextFieldFormat({
    this.textFieldParamsFactory,
  });

  @override
  String? fromView(BuildContext context, String? value) => value;

  @override
  String? toView(BuildContext context, String? value) => value;

  @override
  Widget createFieldWidget(BuildContext context, FieldSchema field) {
    final textFieldParams = textFieldParamsFactory?.call(context);
    return FlashTextField(
      key: ObjectKey(field),
      field: field as ValueSchema,
      textFieldParams: textFieldParams,
    );
  }
}
