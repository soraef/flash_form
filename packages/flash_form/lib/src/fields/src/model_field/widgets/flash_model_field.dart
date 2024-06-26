import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class FlashModelField extends StatelessWidget {
  final ModelSchema form;
  final bool isListView;
  const FlashModelField({
    super.key,
    required this.form,
    this.isListView = false,
  });

  @override
  Widget build(BuildContext context) {
    return FieldBuilder(
      builder: (context) {
        if (isListView) {
          if (form.layout == null) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final field = form.fields[index];
                return field.build();
              },
              itemCount: form.fields.length,
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                final field = form.layout![index];
                return field.build();
              },
              itemCount: form.layout!.length,
            );
          }
        }

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
      },
      field: form,
    );
  }
}
