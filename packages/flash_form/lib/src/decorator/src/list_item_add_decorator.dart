import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class ListItemAddDecorator implements FieldDecorator {
  final EdgeInsetsGeometry padding;
  final String? addText;

  const ListItemAddDecorator({
    this.padding = const EdgeInsets.only(top: 16.0),
    this.addText = 'Add',
  });

  @override
  Widget build(Widget fieldWidget, FieldSchema flashField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        fieldWidget,
        Padding(
          padding: padding,
          child: OutlinedButton(
            child: Text(addText ?? 'Add'),
            onPressed: () {
              if (flashField is ListSchema) {
                flashField.addField();
              }
            },
          ),
        ),
      ],
    );
  }
}
