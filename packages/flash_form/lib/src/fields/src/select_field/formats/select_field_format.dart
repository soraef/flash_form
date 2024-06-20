import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

enum SelectFieldMode {
  dropdown,
  autocomplete,
}

class SelectFieldFormat<T extends Object> extends ValueFieldFormat<T, String> {
  final List<T>? options;
  final String? Function(T? value) toDisplay;
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
    required String? Function(T? value) toDisplay,
    DropdownParameters? dropdownParams,
  }) =>
      SelectFieldFormat(
        options: options,
        toDisplay: toDisplay,
        mode: SelectFieldMode.dropdown,
        dropdownParams: dropdownParams,
      );

  factory SelectFieldFormat.autocomplete({
    required String? Function(T? value) toDisplay,
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
  Widget createFieldWidget(FlashField field) {
    if (mode == SelectFieldMode.autocomplete) {
      return FlashAutoCompleteField<T>(
        key: ObjectKey(field),
        field: field as ValueField,
        params: autocompleteParams,
        optionsBuilder: optionsBuilder!,
      );
    }

    return FlashDropdownField(
      key: ObjectKey(field),
      field: field as ValueField,
      dropdownParams: dropdownParams,
    );
  }

  @override
  T? fromView(String? value) {
    for (var option in options!) {
      if (toDisplay(option) == value) {
        return option;
      }
    }
    return null;
  }

  @override
  String? toView(T? value) => toDisplay(value);
}
