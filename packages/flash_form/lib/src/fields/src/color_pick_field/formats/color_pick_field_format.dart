import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

import '../widgets/flash_color_pick_field.dart';

class ColorPickFieldFormat extends ValueFieldFormat<Color, Color> {
  final List<List<Color>> colors;
  final int? colorSize;

  ColorPickFieldFormat({
    required this.colors,
    this.colorSize,
  });

  @override
  Widget createFieldWidget(BuildContext context, FieldSchema field) {
    return FlashColorPickField(
      key: ObjectKey(field),
      field: field as ValueSchema,
    );
  }

  @override
  Color? fromView(BuildContext context, Color? value) {
    return value;
  }

  @override
  Color? toView(BuildContext context, Color? value) {
    return value;
  }
}
