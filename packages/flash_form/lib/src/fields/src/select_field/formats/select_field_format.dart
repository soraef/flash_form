import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

enum SelectFieldMode {
  dropdown,
  autocomplete,
}

class SelectFieldFormat<T extends Object> extends ValueFieldFormat<T, String> {
  final List<T>? options;
  final String? Function(BuildContext context, T? value) toDisplay;
  final SelectFieldMode mode;
  final DropdownParameters? dropdownParams;
  final AutocompleteParameters<T>? autocompleteParams;
  final Iterable<T> Function(String text)? optionsBuilder;

  SelectFieldFormat({
    required this.toDisplay,
    this.options,
    this.mode = SelectFieldMode.dropdown,
    this.dropdownParams,
    this.autocompleteParams,
    this.optionsBuilder,
  });

  factory SelectFieldFormat.dropdown({
    required List<T> options,
    required String? Function(BuildContext context, T? value) toDisplay,
    DropdownParameters? dropdownParams,
  }) =>
      SelectFieldFormat(
        options: options,
        toDisplay: toDisplay,
        mode: SelectFieldMode.dropdown,
        dropdownParams: dropdownParams,
      );

  factory SelectFieldFormat.autocomplete({
    required String? Function(BuildContext context, T? value) toDisplay,
    AutocompleteParameters<T>? autocompleteParams,
    required Iterable<T> Function(String text) optionsBuilder,
  }) =>
      SelectFieldFormat(
        toDisplay: toDisplay,
        mode: SelectFieldMode.autocomplete,
        autocompleteParams: autocompleteParams,
        optionsBuilder: optionsBuilder,
      );

  @override
  Widget createFieldWidget(BuildContext context, FieldSchema field) {
    if (mode == SelectFieldMode.autocomplete) {
      return FlashAutoCompleteField<T>(
        key: ObjectKey(field),
        field: field as ValueSchema,
        params: autocompleteParams,
        optionsBuilder: optionsBuilder!,
      );
    }

    return FlashDropdownField(
      key: ObjectKey(field),
      field: field as ValueSchema,
      dropdownParams: dropdownParams,
    );
  }

  @override
  T? fromView(BuildContext context, String? value) {
    for (var option in options!) {
      if (toDisplay(context, option) == value) {
        return option;
      }
    }
    return null;
  }

  @override
  String? toView(BuildContext context, T? value) => toDisplay(context, value);
}
