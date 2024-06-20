import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class GroupLayout extends FieldLayout {
  final List<FieldSchema> children;
  final Widget label;

  GroupLayout({
    required this.label,
    required this.children,
  });

  @override
  Widget build() {
    return Column(
      children: [
        label,
        Column(
          children: children.map((child) => child.build()).toList(),
        ),
      ],
    );
  }
}
