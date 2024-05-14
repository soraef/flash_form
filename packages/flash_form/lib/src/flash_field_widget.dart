import 'package:flutter/material.dart';

import 'flash_field.dart';
import 'flash_field_event.dart';

class FlashFormWidget extends StatelessWidget {
  final FlashForm form;
  const FlashFormWidget({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: form.fields
          .map((field) => field.fieldFormat.createFieldWidget(field))
          .toList(),
    );
  }
}

class FlashFieldWidget extends StatefulWidget {
  final FlashField field;
  final Widget Function(BuildContext context) builder;
  const FlashFieldWidget({
    super.key,
    required this.field,
    required this.builder,
  });

  @override
  State<FlashFieldWidget> createState() => _FlashFieldWidgetState();
}

class _FlashFieldWidgetState extends State<FlashFieldWidget> {
  @override
  void initState() {
    super.initState();
    widget.field.addListener(_updateValue);
  }

  void _updateValue() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.field.removeListener(_updateValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}

class FlashFormTextField<T> extends StatefulWidget {
  final ValueField field;
  const FlashFormTextField({super.key, required this.field});

  @override
  State<FlashFormTextField> createState() => _FlashFormTextFieldState();
}

class _FlashFormTextFieldState extends State<FlashFormTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.field.viewValue);
    _controller.addListener(_onTextChanged);
    widget.field.addListener(_onFieldChanged);
  }

  void _onTextChanged() {
    final currentText = widget.field.viewValue;
    if (currentText != _controller.text) {
      widget.field.updateValue(
        widget.field.convertViewToValue(_controller.text),
      );
    }
  }

  void _onFieldChanged() {
    final currentText = widget.field.viewValue;
    if (currentText == _controller.text) {
      return;
    }

    // 現在のカーソル位置を保持
    int cursorPosition = _controller.selection.start;

    // テキストフィールドの値を更新
    _controller.text = widget.field.viewValue;

    // カーソル位置を復元
    if (cursorPosition >= 0 && cursorPosition <= _controller.text.length) {
      _controller.selection = TextSelection.collapsed(offset: cursorPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.field.label,
      ),
    );
  }
}

class ListFieldWidget extends StatelessWidget {
  final ListField field;
  const ListFieldWidget({
    super.key,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return ListFieldBuilder(
      field: field,
      topBuilder: (context) {
        return Row(
          children: [Text(field.label)],
        );
      },
      itemBuilder: (context, item) {
        return Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              key: UniqueKey(),
              children: [
                Expanded(
                  child: item.fieldFormat.createFieldWidget(item),
                ),
                IconButton(
                  onPressed: () {
                    item.emitEventToParent!(ListItemRemoveEvent(item));
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        );
      },
      bottomBuilder: (context) {
        return Row(
          children: [
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                field.addField();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class ListFieldBuilder extends StatelessWidget {
  final ListField field;
  final Widget Function(BuildContext context)? topBuilder;
  final Widget Function(BuildContext context)? bottomBuilder;
  final Widget Function(BuildContext context, FlashField field) itemBuilder;

  const ListFieldBuilder({
    super.key,
    required this.field,
    required this.topBuilder,
    required this.bottomBuilder,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FlashFieldWidget(
      field: field,
      builder: (context) => Column(
        children: [
          if (topBuilder != null) topBuilder!(context),
          ...field.children.map((child) {
            return itemBuilder(context, child);
          }),
          if (bottomBuilder != null) bottomBuilder!(context),
        ],
      ),
    );
  }
}

class TypeFieldWidget extends StatelessWidget {
  final TypeField field;
  const TypeFieldWidget({
    super.key,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return FlashFieldWidget(
      builder: (context) => Column(
        children: [
          DropdownButton(
            value: field.type,
            items: field.fields.keys
                .map((key) => DropdownMenuItem(
                      value: key,
                      child: Text(key.toString()),
                    ))
                .toList(),
            onChanged: (value) {
              field.updateType(value);
            },
          ),
          if (field.selectedFieldFormat != null)
            field.selectedFieldFormat!.createFieldWidget(field.selectedField!),
        ],
      ),
      field: field,
    );
  }
}
