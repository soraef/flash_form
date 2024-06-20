import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class RowLayout extends FieldLayout {
  final List<FieldLayout> children;
  // final EdgeInsets itemPadding;
  final double spacing;

  RowLayout({
    required this.children,
    // this.itemPadding = const EdgeInsets.all(8.0),
    this.spacing = 16.0,
  });

  @override
  Widget build() {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++)
          Expanded(
            child: Padding(
              padding:
                  EdgeInsets.only(right: i < children.length - 1 ? spacing : 0),
              child: children[i].build(),
            ),
          ),
      ],
    );
  }
}
