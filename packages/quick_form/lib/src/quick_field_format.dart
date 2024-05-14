import 'package:flutter/widgets.dart';

import 'quick_field.dart';
import 'quick_field_preview.dart';
import 'quick_field_widget.dart';

abstract class FieldFormat {
  final String name;

  const FieldFormat({
    required this.name,
  });

  Widget createFieldWidget(QuickField field);
  Widget createPreviewWidget(QuickField field) {
    return DefaultPreviewWidget(
      key: UniqueKey(),
      field: field,
    );
  }
}

abstract class ValueFieldFormat<ValueType, ViewType> extends FieldFormat {
  ValueFieldFormat(String name) : super(name: name);

  ValueType? fromView(ViewType? value);

  ViewType? toView(ValueType? value);
}

class TextFieldFormat extends ValueFieldFormat<String, String> {
  TextFieldFormat() : super('TextFieldFormat');

  @override
  String? fromView(String? value) => value;

  @override
  String? toView(String? value) => value;

  @override
  Widget createFieldWidget(QuickField field) {
    return QuickFormTextField(
      key: UniqueKey(),
      field: field as ValueField,
    );
  }
}

class NumberFieldFormat extends ValueFieldFormat<int, String> {
  NumberFieldFormat() : super('NumberFieldFormat');

  @override
  int? fromView(String? value) => int.tryParse(value ?? '');

  @override
  String? toView(int? value) => value?.toString();

  @override
  Widget createFieldWidget(QuickField field) {
    return QuickFormTextField(
      key: UniqueKey(),
      field: field as ValueField,
    );
  }
}

class ListFieldFormat extends FieldFormat {
  const ListFieldFormat() : super(name: 'ListField');

  @override
  Widget createFieldWidget(QuickField field) {
    return ListFieldWidget(field: field as ListField);
  }

  @override
  Widget createPreviewWidget(QuickField field) {
    return ListPreviewWidget(
      key: UniqueKey(),
      field: field as ListField,
    );
  }
}

class ModelFieldFormat extends FieldFormat {
  const ModelFieldFormat() : super(name: 'ModelField');

  @override
  Widget createFieldWidget(QuickField field) {
    return QuickFormWidget(
      form: field as QuickForm,
    );
  }

  @override
  Widget createPreviewWidget(QuickField field) {
    return QuickPreviewWidget(form: field as QuickForm);
  }
}

class TypeFieldFormat extends FieldFormat {
  const TypeFieldFormat() : super(name: 'TypeField');

  @override
  Widget createFieldWidget(QuickField field) {
    return TypeFieldWidget(field: field as TypeField);
  }

  @override
  Widget createPreviewWidget(QuickField field) {
    return TypePreviewWidget(field: field as TypeField);
  }
}
