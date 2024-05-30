import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class LableWrapper<TValue, TView> implements FieldWrapper<TValue, TView> {
  final String text;
  final String? description;
  final EdgeInsets padding;

  LableWrapper(
    this.text, {
    this.description,
    this.padding = const EdgeInsets.only(top: 16.0),
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
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
  final String? description;
  final bool enbableMenu;

  const DefaultValueWrapper({
    this.label,
    this.description,
    this.padding = const EdgeInsets.only(bottom: 0.0),
    this.enbableMenu = true,
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    final isListItem = flashField.isListItem;
    var widget = fieldWidget;
    if (label != null) {
      widget = LableWrapper<TValue, TView>(
        label!,
        description: description,
      ).build(widget, flashField);
    }
    widget = ErrorMessageWrapper<TValue, TView>().build(widget, flashField);
    if (isListItem && enbableMenu) {
      widget = const ListItemMenuWrapper(
        rowAlignment: CrossAxisAlignment.center,
      ).build(widget, flashField);
    }

    widget = PaddingWrapper(padding).build(widget, flashField);
    return widget;
  }
}

class DefaultTypeWrapper<TValue, TView> implements FieldWrapper<TValue, TView> {
  final EdgeInsetsGeometry padding;
  final String? label;
  final String? description;
  final bool enbableMenu;

  const DefaultTypeWrapper({
    this.label,
    this.description,
    this.padding = const EdgeInsets.all(16.0),
    this.enbableMenu = true,
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    var widget =
        ErrorMessageWrapper<TValue, TView>().build(fieldWidget, flashField);
    if (flashField.isListItem && enbableMenu) {
      widget = const ListItemMenuWrapper().build(widget, flashField);
    }
    if (label != null) {
      widget = LableWrapper<TValue, TView>(
        label!,
        description: description,
        padding: const EdgeInsets.only(top: 0.0),
      ).build(widget, flashField);
    }

    widget = CardWrapper(padding: padding).build(widget, flashField);
    return widget;
  }
}

class DefaultListWrapper implements FieldWrapper {
  final EdgeInsetsGeometry padding;
  final String? label;
  final String? description;

  const DefaultListWrapper({
    this.label,
    this.description,
    this.padding = const EdgeInsets.only(bottom: 0.0),
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    var widget = ErrorMessageWrapper().build(fieldWidget, flashField);
    if (label != null) {
      widget = LableWrapper(
        label!,
        description: description,
      ).build(widget, flashField);
    }
    widget = PaddingWrapper(padding).build(widget, flashField);
    widget = const ListItemAddWrapper().build(widget, flashField);
    return widget;
  }
}

class DefaultObjectWrapper implements FieldWrapper {
  final EdgeInsetsGeometry padding;
  final String? label;
  final String? description;
  final bool enbableMenu;

  const DefaultObjectWrapper({
    this.label,
    this.description,
    this.padding = const EdgeInsets.only(bottom: 0.0),
    this.enbableMenu = true,
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    var widget = ErrorMessageWrapper().build(fieldWidget, flashField);

    if (flashField.isListItem && enbableMenu) {
      widget = const ListItemMenuWrapper().build(widget, flashField);
    }

    if (label != null) {
      widget = LableWrapper(
        label!,
        description: description,
      ).build(widget, flashField);
    }
    widget = PaddingWrapper(padding).build(widget, flashField);
    return widget;
  }
}

class ListItemMenuWrapper implements FieldWrapper {
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment rowAlignment;

  const ListItemMenuWrapper({
    this.padding = const EdgeInsets.all(8.0),
    this.rowAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    return Row(
      crossAxisAlignment: rowAlignment,
      children: [
        Expanded(child: fieldWidget),
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  title:
                      const Text('Remove', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    flashField.sendEvent(ListItemRemoveEvent(flashField));
                    Navigator.pop(context);
                  },
                ),
              ),

              /// 一つ上に追加
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Add above'),
                  onTap: () {
                    flashField.sendEvent(ListItemAddEvent(
                      field: flashField,
                      position: InsertPosition.above,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ),

              /// 一つ下に追加
              PopupMenuItem(
                child: ListTile(
                  title: const Text('Add below'),
                  onTap: () {
                    flashField.sendEvent(ListItemAddEvent(
                      field: flashField,
                      position: InsertPosition.below,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ),
            ];
          },
        ),
        // IconButton(
        //   icon: const Icon(Icons.close),
        //   onPressed: () {
        //     flashField.sendEvent(ListItemRemoveEvent(flashField));
        //   },
        // ),
      ],
    );
  }
}

class ListItemAddWrapper implements FieldWrapper {
  final EdgeInsetsGeometry padding;
  final String? addText;

  const ListItemAddWrapper({
    this.padding = const EdgeInsets.only(top: 16.0),
    this.addText = 'Add',
  });

  @override
  Widget build(Widget fieldWidget, FlashField flashField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        fieldWidget,
        Padding(
          padding: padding,
          child: OutlinedButton(
            child: Text(addText ?? 'Add'),
            onPressed: () {
              if (flashField is ListField) {
                flashField.addField();
              }
            },
          ),
        ),
      ],
    );
  }
}
