import 'package:flash_form/flash_form.dart';
import 'package:flash_form/src/fields/field_widgets.dart';
import 'package:flutter/src/widgets/framework.dart';

class MultiSelectFieldFormat<T>
    extends ValueFieldFormat<List<T>, List<String>> {
  final List<T> options;
  final String Function(T value) toDisplay;

  MultiSelectFieldFormat._({
    required this.toDisplay,
    required this.options,
  });

  factory MultiSelectFieldFormat.checkbox({
    required List<T> options,
    required String Function(T value) toDisplay,
  }) =>
      MultiSelectFieldFormat._(
        options: options,
        toDisplay: toDisplay,
      );

  @override
  Widget createFieldWidget(BuildContext context, FieldSchema field) {
    return FlashCheckboxGroupField(
        key: ObjectKey(field),
        field: field as ValueSchema<List<T>, List<String>>);
  }

  @override
  List<T>? fromView(BuildContext context, List<String>? value) {
    return value?.map((e) {
      return options.firstWhere((element) => toDisplay(element) == e);
    }).toList();
  }

  @override
  List<String>? toView(BuildContext context, List<T>? value) {
    return value?.map((e) => toDisplay(e)).toList();
  }

  String toDisplayString(T value) {
    return toDisplay(value);
  }
}
