import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class FlashFormWidget extends StatelessWidget {
  final ObjectField form;
  const FlashFormWidget({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (form.layout == null)
          Expanded(
            child: Column(
              children: form.fields.map((field) => field.build()).toList(),
            ),
          ),
        if (form.layout != null)
          Expanded(
            child: Column(
              children: form.layout!.map((field) => field.build()).toList(),
            ),
          ),
        if (form.isListItem)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              form.sendEvent(ListItemRemoveEvent(form));
            },
          ),
      ],
    );
  }
}

class LayoutModelFieldWidget extends StatelessWidget {
  final ObjectField form;
  const LayoutModelFieldWidget({
    super.key,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    final format = form.fieldFormat as LayoutModelFieldFormat;
    return format.layoutBuilder(form);
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

  @override
  void didUpdateWidget(covariant FlashFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.field != widget.field) {
      oldWidget.field.removeListener(_updateValue);
      widget.field.addListener(_updateValue);
    }
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
        return Container();
      },
      itemBuilder: (context, item) {
        return item.build();
      },
      bottomBuilder: (context) {
        // return Row(
        //   children: [
        //     const Spacer(),
        //     OutlinedButton(
        //       onPressed: () {
        //         field.addField();
        //       },
        //       child: const Text('Add'),
        //     ),
        //   ],
        // );
        return Container();
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
    return Column(
      children: [
        if (topBuilder != null) topBuilder!(context),
        ...field.children.map((child) {
          return itemBuilder(context, child);
        }),
        if (bottomBuilder != null) bottomBuilder!(context),
      ],
    );
  }
}

class TypeFieldWidget<TView, TValue, TOption> extends StatelessWidget {
  final TypeField<TView, TValue, TOption> field;
  const TypeFieldWidget({
    super.key,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            DropdownButton(
              value: field.type,
              items: field.typeOptions
                  .map(
                    (key) => DropdownMenuItem(
                      value: key,
                      child: Text(field.displayOption(key)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                field.updateType(value);
              },
            ),
            const Spacer(),
            if (field.isListItem)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  field.sendEvent(ListItemRemoveEvent(field));
                },
              ),
          ],
        ),
        if (field.selectedFieldFormat != null) field.selectedField!.build(),
      ],
    );
  }
}
