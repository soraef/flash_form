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
  Widget createFieldWidget(FlashField field) {
    return FlashFormTextField(
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
  Widget createFieldWidget(FlashField field) {
    return FlashFormTextField(
      key: UniqueKey(),
      field: field as ValueField,
    );
  }
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
      key: UniqueKey(),
      field: field as ListField,
    );
  }
}

class ModelFieldFormat extends FieldFormat {
  const ModelFieldFormat() : super(name: 'ModelField');

  @override
  Widget createFieldWidget(FlashField field) {
    return FlashFormWidget(
      form: field as FlashForm,
    );
  }

  @override
  Widget createPreviewWidget(FlashField field) {
    return FlashPreviewWidget(form: field as FlashForm);
  }
}

class TypeFieldFormat extends FieldFormat {
  const TypeFieldFormat() : super(name: 'TypeField');

  @override
  Widget createFieldWidget(FlashField field) {
    return TypeFieldWidget(field: field as TypeField);
  }

  @override
  Widget createPreviewWidget(FlashField field) {
    return TypePreviewWidget(field: field as TypeField);
  }
}
