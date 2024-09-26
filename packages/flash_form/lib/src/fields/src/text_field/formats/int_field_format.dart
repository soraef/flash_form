import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntFieldFormat extends ValueFieldFormat<int, String> {
  final TextFieldParameters Function(BuildContext context)?
      textFieldParamsFactory;
  IntFieldFormat({
    this.textFieldParamsFactory,
  });

  static final TextFieldParameters defaultTextFieldParams = TextFieldParameters(
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  );

  @override
  int? fromView(BuildContext context, String? value) =>
      int.tryParse(value ?? '');

  @override
  String? toView(BuildContext context, int? value) => value?.toString();

  @override
  Widget createFieldWidget(BuildContext context, FieldSchema field) {
    final textFieldParams = textFieldParamsFactory?.call(context);
    return FlashTextField(
      key: ObjectKey(field),
      field: field as ValueSchema,
      textFieldParams: defaultTextFieldParams.merge(textFieldParams),
    );
  }
}
