import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class PaddingDecorator implements FieldDecorator {
  final EdgeInsetsGeometry padding;

  PaddingDecorator(this.padding);

  @override
  Widget build(Widget fieldWidget, FieldSchema flashField) {
    return Padding(
      padding: padding,
      child: fieldWidget,
    );
  }
}
