import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

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
