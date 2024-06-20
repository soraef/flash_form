import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class LableDecorator<TValue, TView> implements FieldDecorator<TValue, TView> {
  final String text;
  final String? description;
  final EdgeInsets padding;

  LableDecorator(
    this.text, {
    this.description,
    this.padding = const EdgeInsets.only(top: 16.0),
  });

  @override
  Widget build(Widget fieldWidget, FieldSchema flashField) {
    final isRequired =
        flashField.validators.any((element) => element is RequiredValidator);
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(text, style: const TextStyle(fontSize: 12)),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ),
          if (description != null)
            Text(
              description!,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          fieldWidget,
        ],
      ),
    );
  }
}
