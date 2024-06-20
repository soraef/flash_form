import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

abstract class FieldDecorator<TValue, TView> {
  FieldDecorator();

  Widget build(Widget fieldWidget, FieldSchema flashField);
}
