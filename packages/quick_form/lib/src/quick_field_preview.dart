import 'package:flutter/widgets.dart';
import 'package:quick_form/quick_form.dart';

class QuickPreviewWidget extends StatelessWidget {
  final QuickForm form;
  const QuickPreviewWidget({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: form.fields
          .map((field) => field.fieldFormat.createPreviewWidget(field))
          .toList(),
    );
  }
}

class DefaultPreviewWidget extends StatelessWidget {
  final QuickField field;
  const DefaultPreviewWidget({
    super.key,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (field.listItemMetadata == null) Text(field.label),
        const Spacer(),
        Text(field.value.toString()),
      ],
    );
  }
}

class ListPreviewWidget extends StatelessWidget {
  final ListField field;
  const ListPreviewWidget({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(field.label),
          ],
        ),
        ...field.children.map((child) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('${field.label} ${child.listItemMetadata!.index}'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: child.fieldFormat.createPreviewWidget(child),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class TypePreviewWidget extends StatelessWidget {
  final TypeField field;
  const TypePreviewWidget({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(field.label),
          ],
        ),
        if (field.selectedFieldFormat != null)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Type'),
                    const Spacer(),
                    Text(field.type.toString()),
                  ],
                ),
                field.selectedField!.fieldFormat
                    .createPreviewWidget(field.selectedField!),
              ],
            ),
          ),
      ],
    );
  }
}
