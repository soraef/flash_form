import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class ErrorMessageDecorator<TValue, TView>
    implements FieldDecorator<TValue, TView> {
  ErrorMessageDecorator();

  @override
  Widget build(Widget fieldWidget, FieldSchema flashField) {
    final errors = flashField.validatorResults;

    return Builder(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            fieldWidget,
            // Text(text, style: TextStyle(color: Colors.red, fontSize: 12)),
            if (errors.isNotEmpty)
              Column(
                children: errors
                    .map(
                      (error) => Text(
                        error.getMessage(context) ?? '',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )
                    .toList(),
              ),
          ],
        );
      },
    );
  }
}
