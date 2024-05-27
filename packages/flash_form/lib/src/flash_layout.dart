import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

abstract class FlashLayout {
  const FlashLayout();

  Widget build();
}

class CustomLayout extends FlashLayout {
  final Widget Function() builder;

  CustomLayout({
    required this.builder,
  });

  @override
  Widget build() {
    return builder();
  }
}

class RowLayout extends FlashLayout {
  final List<FlashLayout> children;
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

class GroupLayout extends FlashLayout {
  final List<FlashField> children;
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
