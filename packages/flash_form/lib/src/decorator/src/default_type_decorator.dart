import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class DefaultTypeDecorator<TValue, TView>
    implements FieldDecorator<TValue, TView> {
  final EdgeInsetsGeometry padding;
  final String? label;
  final String? description;
  final bool enbableMenu;

  const DefaultTypeDecorator({
    this.label,
    this.description,
    this.padding = const EdgeInsets.all(16.0),
    this.enbableMenu = true,
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    var widget =
        ErrorMessageDecorator<TValue, TView>().build(fieldWidget, flashField);
    if (flashField.isListItem && enbableMenu) {
      widget = const ListItemMenuDecorator().build(widget, flashField);
    }
    if (label != null) {
      widget = LableDecorator<TValue, TView>(
        label!,
        description: description,
        padding: const EdgeInsets.only(top: 0.0),
      ).build(widget, flashField);
    }

    widget = CardDecorator(padding: padding).build(widget, flashField);
    return widget;
  }
}
