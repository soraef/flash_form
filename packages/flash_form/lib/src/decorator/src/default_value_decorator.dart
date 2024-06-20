import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class DefaultValueDecorator<TValue, TView>
    implements FieldDecorator<TValue, TView> {
  final EdgeInsetsGeometry padding;
  final String? label;
  final String? description;
  final bool enbableMenu;

  const DefaultValueDecorator({
    this.label,
    this.description,
    this.padding = const EdgeInsets.symmetric(vertical: 8.0),
    this.enbableMenu = true,
  });

  @override
  Widget build(Widget fieldWidget, FieldSchema flashField) {
    final isListItem = flashField.isListItem;
    var widget = fieldWidget;
    if (label != null) {
      widget = LableDecorator<TValue, TView>(
        label!,
        description: description,
      ).build(widget, flashField);
    }
    widget = ErrorMessageDecorator<TValue, TView>().build(widget, flashField);
    if (isListItem && enbableMenu) {
      widget = const ListItemMenuDecorator(
        rowAlignment: CrossAxisAlignment.center,
      ).build(widget, flashField);
    }

    widget = PaddingDecorator(padding).build(widget, flashField);
    return widget;
  }
}
