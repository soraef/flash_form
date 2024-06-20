import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

typedef BuildWrapper<TValue, TView> = Widget Function(
  Widget fieldWidget,
  FlashField<TValue, TView> flashField,
);

abstract class FieldDecorator<TValue, TView> {
  FieldDecorator();

  Widget build(Widget fieldWidget, FlashField flashField);
}
