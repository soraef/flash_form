import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

List<FieldDecorator> defaultValueDecorator(BuildContext context) {
  return [const DefaultValueDecorator()];
}

class ValueSchema<TValue, TView> extends FieldSchema<TValue, TView> {
  @override
  TValue? value;
  void Function(FormEvent event, ValueSchema<TValue, TView> field)? handleEvent;

  ValueSchema({
    required ValueFieldFormat<TValue, TView> super.fieldFormat,
    required super.parent,
    this.value,
    super.decorators = defaultValueDecorator,
    super.validators,
    this.handleEvent,
  });

  @override
  void updateValue(TValue? newValue) {
    value = newValue;
    context.sendEvent(ValueChangeEvent(id: id, value: newValue));
    notifyListeners();
  }

  TView? viewValue(BuildContext context) =>
      (fieldFormat as ValueFieldFormat).toView(context, value);
  TValue? convertViewToValue(BuildContext context, TView? viewValue) {
    return (fieldFormat as ValueFieldFormat).fromView(context, viewValue);
  }

  @override
  void onEvent(FormEvent event) {
    super.onEvent(event);
    handleEvent?.call(event, this);
  }

  @override
  SchemaType get fieldType => SchemaType.value;

  @override
  bool get hasFocusRecursive => hasFocus;
}
