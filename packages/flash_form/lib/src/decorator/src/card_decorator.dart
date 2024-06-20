import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class CardDecorator implements FieldDecorator {
  final EdgeInsetsGeometry padding;
  CardDecorator({
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(Widget fieldWidget, FieldSchema flashField) {
    return Card.outlined(
      child: Padding(
        padding: padding,
        child: fieldWidget,
      ),
    );
  }
}
