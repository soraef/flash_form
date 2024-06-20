import 'package:flutter/widgets.dart';

import 'flash_field.dart';

class FlashPreviewWidget extends StatelessWidget {
  final ObjectField form;
  const FlashPreviewWidget({super.key, required this.form});

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
  final FlashField field;
  const DefaultPreviewWidget({
    super.key,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
        // Row(
        //   children: [
        //     Text(field.label),
        //   ],
        // ),
        ...field.children.map((child) {
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: [
                // Row(
                //   children: [
                //     Text('${field.label} ${child.fieldType}'),
                //   ],
                // ),
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
        // Row(
        //   children: [
        //     Text(field.label),
        //   ],
        // ),
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
                    Text(field.fieldType.toString()),
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
