import 'package:flutter/widgets.dart';

import 'flash_field.dart';
import 'flash_field_preview.dart';
import 'flash_field_widget.dart';

abstract class FieldFormat {
  final String name;

  const FieldFormat({
    required this.name,
  });

  Widget createFieldWidget(FlashField field);
  Widget createPreviewWidget(FlashField field) {
    return DefaultPreviewWidget(
      key: UniqueKey(),
      field: field,
    );
  }
}

abstract class ValueFieldFormat<TValue, TView> extends FieldFormat {
  ValueFieldFormat(String name) : super(name: name);

  TValue? fromView(TView? value);

  TView? toView(TValue? value);
}

class TextFieldFormat extends ValueFieldFormat<String, String> {
  final TextFieldParameters? textFieldParams;
  TextFieldFormat({
    this.textFieldParams,
  }) : super('TextFieldFormat');

  @override
  String? fromView(String? value) => value;

  @override
  String? toView(String? value) => value;

  @override
  Widget createFieldWidget(FlashField field) {
    return FlashFormTextField(
      key: ObjectKey(field),
      field: field as ValueField,
      textFieldParams: textFieldParams,
    );
  }
}

class NumberFieldFormat extends ValueFieldFormat<int, String> {
  final TextFieldParameters? textFieldParams;
  NumberFieldFormat({
    this.textFieldParams,
  }) : super('NumberFieldFormat');

  @override
  int? fromView(String? value) => int.tryParse(value ?? '');

  @override
  String? toView(int? value) => value?.toString();

  @override
  Widget createFieldWidget(FlashField field) {
    return FlashFormTextField(
      key: ObjectKey(field),
      field: field as ValueField,
      textFieldParams: textFieldParams,
    );
  }
}

class DropdownFieldFormat<T> extends ValueFieldFormat<T, String> {
  final List<T> options;
  final String? Function(T? value) toDisplay;
  final DropdownParameters? dropdownParams;

  DropdownFieldFormat({
    required this.options,
    required this.toDisplay,
    this.dropdownParams,
  }) : super('DropdownFieldFormat');

  @override
  Widget createFieldWidget(FlashField field) {
    return FlashFormDropdown(
      key: ObjectKey(field),
      field: field as ValueField,
      dropdownParams: dropdownParams,
    );
  }

  @override
  T? fromView(String? value) {
    for (var option in options) {
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
  const ListFieldFormat() : super(name: 'ListField');

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
  const ModelFieldFormat() : super(name: 'ModelField');

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
  }) : super(name: 'LayoutModelField');

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
  const TypeFieldFormat() : super(name: 'TypeField');

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
