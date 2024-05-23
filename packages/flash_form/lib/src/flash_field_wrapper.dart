import 'package:flutter/material.dart';

import 'flash_field.dart';

class LableWrapper<TValue, TView> implements FieldWrapper<TValue, TView> {
  final String text;

  LableWrapper(this.text);

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: const TextStyle(fontSize: 12)),
        fieldWidget,
      ],
    );
  }
}

class ErrorMessageWrapper<TValue, TView>
    implements FieldWrapper<TValue, TView> {
  ErrorMessageWrapper();

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    final errors = flashField.validatorResults;

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
                    error.message ?? '',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class CardWrapper implements FieldWrapper {
  CardWrapper();

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: fieldWidget,
            ),
          ],
        ),
      ),
    );
  }
}

class PaddingWrapper implements FieldWrapper {
  final EdgeInsetsGeometry padding;

  PaddingWrapper(this.padding);

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    return Padding(
      padding: padding,
      child: fieldWidget,
    );
  }
}
