import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class DefaultListDecorator implements FieldDecorator {
  final EdgeInsetsGeometry padding;
  final String? label;
  final String? description;
  final String? addText;

  const DefaultListDecorator({
    this.label,
    this.description,
    this.addText,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
  });

  @override
  Widget build(Widget fieldWidget, FieldSchema flashField) {
    var widget = ErrorMessageDecorator().build(fieldWidget, flashField);
    if (label != null) {
      widget = LableDecorator(
        label!,
        description: description,
      ).build(widget, flashField);
    }
    widget = PaddingDecorator(padding).build(widget, flashField);
    widget = ListItemAddDecorator(
      addText: addText,
    ).build(widget, flashField);
    return widget;
  }
}
