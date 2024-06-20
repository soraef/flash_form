import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class FlashTypeField<TView, TValue, TOption> extends StatelessWidget {
  final TypeSchema<TView, TValue, TOption> field;
  const FlashTypeField({
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
          ],
        ),
        if (field.selectedFieldFormat != null) field.selectedField!.build(),
      ],
    );
  }
}
