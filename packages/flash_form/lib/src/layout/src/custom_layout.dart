import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class CustomLayout extends FieldLayout {
  final Widget Function() builder;

  CustomLayout({
    required this.builder,
  });

  @override
  Widget build() {
    return builder();
  }
}
