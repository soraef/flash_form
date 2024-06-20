import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class FieldBuilder extends StatefulWidget {
  final FieldSchema field;
  final Widget Function(BuildContext context) builder;
  const FieldBuilder({
    super.key,
    required this.field,
    required this.builder,
  });

  @override
  State<FieldBuilder> createState() => _FieldBuilderState();
}

class _FieldBuilderState extends State<FieldBuilder> {
  @override
  void initState() {
    super.initState();
    widget.field.addListener(_updateValue);
  }

  @override
  void didUpdateWidget(covariant FieldBuilder oldWidget) {
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
