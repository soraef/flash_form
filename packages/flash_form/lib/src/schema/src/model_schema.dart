import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

List<FieldDecorator> defaultModelDecorators(BuildContext context) {
  return [const DefaultObjectDecorator()];
}

abstract class ModelSchema<T> extends FieldSchema<T, T> {
  ModelSchema({
    super.decorators = defaultModelDecorators,
    required super.parent,
    super.fieldFormat = const ModelFieldFormat(),
  }) : super();

  List<FieldSchema> get fields;

  List<FieldLayout>? get layout => null;

  T toModel();
  void fromModel(T model);

  @override
  T? get value => toModel();

  @override
  void updateValue(T? newValue) {
    if (newValue == null) {
      return;
    }
    fromModel(newValue);
  }

  @override
  Future<bool> validate() async {
    bool isValid = await super.validate();
    for (var field in fields) {
      isValid = await field.validate() && isValid;
    }
    notifyListeners();

    return isValid;
  }

  @override
  SchemaType get fieldType => SchemaType.model;

  @override
  bool get hasFocusRecursive {
    if (hasFocus) {
      return true;
    }

    for (var field in fields) {
      if (field.hasFocusRecursive) {
        return true;
      }
    }

    return false;
  }
}
