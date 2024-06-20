import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class FlashListField extends StatelessWidget {
  final ListField field;
  const FlashListField({
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
