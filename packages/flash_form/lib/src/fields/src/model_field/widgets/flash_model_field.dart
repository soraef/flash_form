import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class FlashModelField extends StatelessWidget {
  final ObjectField form;
  const FlashModelField({super.key, required this.form});

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
      ],
    );
  }
}
