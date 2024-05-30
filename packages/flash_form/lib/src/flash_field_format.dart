import 'package:flutter/widgets.dart';

import 'field_widgets/field_widgets.dart';
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

class TextFieldFormat extends ValueFieldFormat<String, String> {
  final TextFieldParameters? textFieldParams;
  TextFieldFormat({
    this.textFieldParams,
  });

  @override
  String? fromView(String? value) => value;

  @override
  String? toView(String? value) => value;

  @override
  Widget createFieldWidget(FlashField field) {
    return FlashTextField(
      key: ObjectKey(field),
      field: field as ValueField,
      textFieldParams: textFieldParams,
    );
  }
}

class NumberFieldFormat extends ValueFieldFormat<num, String> {
  final TextFieldParameters? textFieldParams;
  NumberFieldFormat({
    this.textFieldParams,
  });

  @override
  int? fromView(String? value) => int.tryParse(value ?? '');

  @override
  String? toView(num? value) => value?.toString();

  @override
  Widget createFieldWidget(FlashField field) {
    return FlashTextField(
      key: ObjectKey(field),
      field: field as ValueField,
      textFieldParams: textFieldParams,
    );
  }
}

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

class ListFieldFormat extends FieldFormat {
  const ListFieldFormat();

  @override
  Widget createFieldWidget(FlashField field) {
    return ListFieldWidget(field: field as ListField);
  }

  @override
  Widget createPreviewWidget(FlashField field) {
    return ListPreviewWidget(
      key: ObjectKey(field),
      field: field as ListField,
    );
  }
}

class ModelFieldFormat extends FieldFormat {
  const ModelFieldFormat();

  @override
  Widget createFieldWidget(FlashField field) {
    return FlashFormWidget(
      form: field as ObjectField,
    );
  }

  @override
  Widget createPreviewWidget(FlashField field) {
    return FlashPreviewWidget(form: field as ObjectField);
  }
}

class LayoutModelFieldFormat extends FieldFormat {
  final Widget Function(ObjectField form) layoutBuilder;
  const LayoutModelFieldFormat({
    required this.layoutBuilder,
  });

  @override
  Widget createFieldWidget(FlashField field) {
    return LayoutModelFieldWidget(
      form: field as ObjectField,
    );
  }

  @override
  Widget createPreviewWidget(FlashField field) {
    return FlashPreviewWidget(form: field as ObjectField);
  }
}

class TypeFieldFormat<TValue, TView, TOption> extends FieldFormat {
  const TypeFieldFormat();

  @override
  Widget createFieldWidget(FlashField field) {
    return TypeFieldWidget<TValue, TView, TOption>(
      key: ObjectKey(field),
      field: field as TypeField<TValue, TView, TOption>,
    );
  }

  @override
  Widget createPreviewWidget(FlashField field) {
    return TypePreviewWidget(
      field: field as TypeField,
    );
  }
}
