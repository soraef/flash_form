import 'package:flutter/material.dart';

import 'flash_field.dart';
import 'flash_field_validator.dart';

class LableWrapper<TValue, TView> implements FieldWrapper<TValue, TView> {
  final String text;

  LableWrapper(this.text);

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    final isRequired =
        flashField.validators.any((element) => element is RequiredValidator);
    return Column(
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
  final EdgeInsetsGeometry padding;
  CardWrapper({
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    return Card.outlined(
      child: Padding(
        padding: padding,
        child: fieldWidget,
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

class DefaultValueWrapper<TValue, TView>
    implements FieldWrapper<TValue, TView> {
  final EdgeInsetsGeometry padding;
  final String? label;

  const DefaultValueWrapper({
    this.label,
    this.padding = const EdgeInsets.symmetric(vertical: 4.0),
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    var widget = fieldWidget;
    if (label != null) {
      widget = LableWrapper<TValue, TView>(label!).build(widget, flashField);
    }
    widget = ErrorMessageWrapper<TValue, TView>().build(widget, flashField);
    widget = PaddingWrapper(padding).build(widget, flashField);
    return widget;
  }
}

class DefaultTypeWrapper<TValue, TView> implements FieldWrapper<TValue, TView> {
  final EdgeInsetsGeometry padding;
  final String? label;

  const DefaultTypeWrapper({
    this.label,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    var widget =
        ErrorMessageWrapper<TValue, TView>().build(fieldWidget, flashField);
    if (label != null) {
      widget = LableWrapper<TValue, TView>(label!).build(widget, flashField);
    }
    widget = CardWrapper(padding: padding).build(widget, flashField);
    return widget;
  }
}

class DefaultListWrapper implements FieldWrapper {
  final EdgeInsetsGeometry padding;
  final String? label;

  const DefaultListWrapper({
    this.label,
    this.padding = const EdgeInsets.all(0.0),
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    var widget = ErrorMessageWrapper().build(fieldWidget, flashField);
    if (label != null) {
      widget = LableWrapper(label!).build(widget, flashField);
    }
    widget = PaddingWrapper(padding).build(widget, flashField);
    return widget;
  }
}
