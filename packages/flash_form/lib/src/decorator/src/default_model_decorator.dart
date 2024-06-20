import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class DefaultObjectDecorator implements FieldDecorator {
  final EdgeInsetsGeometry padding;
  final String? label;
  final String? description;
  final bool enbableMenu;

  const DefaultObjectDecorator({
    this.label,
    this.description,
    this.padding = const EdgeInsets.only(bottom: 0.0),
    this.enbableMenu = true,
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    var widget = ErrorMessageDecorator().build(fieldWidget, flashField);

    if (flashField.isListItem && enbableMenu) {
      widget = const ListItemMenuDecorator().build(widget, flashField);
    }

    if (label != null) {
      widget = LableDecorator(
        label!,
        description: description,
      ).build(widget, flashField);
    }
    widget = PaddingDecorator(padding).build(widget, flashField);
    return widget;
  }
}
