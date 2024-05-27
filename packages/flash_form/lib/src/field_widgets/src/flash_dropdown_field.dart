import 'package:flutter/material.dart';

import '../../flash_field.dart';
import '../../flash_field_format.dart';

class DropdownParameters<T> {
  final Key? key;

  final List<Widget> Function(BuildContext)? selectedItemBuilder;

  final DropdonwFieldItemParameters? itemParams;

  final Widget? hint;
  final Widget? disabledHint;

  final void Function()? onTap;
  final int elevation;
  final TextStyle? style;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense;
  final bool isExpanded;
  final double? itemHeight;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? dropdownColor;
  final InputDecoration? decoration;
  final void Function(T?)? onSaved;
  final String? Function(T?)? validator;
  final AutovalidateMode? autovalidateMode;
  final double? menuMaxHeight;
  final bool? enableFeedback;
  final AlignmentGeometry alignment;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  DropdownParameters({
    this.key,
    this.itemParams,
    this.selectedItemBuilder,
    this.hint,
    this.disabledHint,
    this.onTap,
    this.elevation = 8,
    this.style,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = true,
    this.isExpanded = false,
    this.itemHeight,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.decoration,
    this.onSaved,
    this.validator,
    this.autovalidateMode,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
    this.padding,
  });
}

class DropdonwFieldItemParameters {
  final AlignmentGeometry alignment;
  final TextStyle? style;

  DropdonwFieldItemParameters({
    this.alignment = AlignmentDirectional.centerStart,
    this.style,
  });
}

class FlashDropdownField<T> extends StatelessWidget {
  final ValueField field;
  final DropdownParameters? dropdownParams;

  const FlashDropdownField({
    super.key,
    required this.field,
    this.dropdownParams,
  });

  @override
  Widget build(BuildContext context) {
    final format = field.fieldFormat as SelectFieldFormat<T>;
    final params = dropdownParams ?? DropdownParameters();
    return DropdownButtonFormField(
      value: field.value,
      items: [
        for (var option in format.options)
          DropdownMenuItem(
            value: option,
            alignment: params.itemParams?.alignment ??
                AlignmentDirectional.centerStart,
            child: Text(
              format.toView(option) ?? '',
              style: params.itemParams?.style,
            ),
          )
      ],
      onChanged: (value) {
        field.updateValue(value);
      },
      selectedItemBuilder: params.selectedItemBuilder,
      hint: params.hint,
      disabledHint: params.disabledHint,
      onTap: params.onTap,
      elevation: params.elevation,
      style: params.style,
      icon: params.icon,
      iconDisabledColor: params.iconDisabledColor,
      iconEnabledColor: params.iconEnabledColor,
      iconSize: params.iconSize,
      isDense: params.isDense,
      isExpanded: params.isExpanded,
      itemHeight: params.itemHeight,
      focusColor: params.focusColor,
      focusNode: params.focusNode,
      autofocus: params.autofocus,
      dropdownColor: params.dropdownColor,
      decoration: params.decoration,
      onSaved: params.onSaved,
      validator: params.validator,
      autovalidateMode: params.autovalidateMode,
      menuMaxHeight: params.menuMaxHeight,
      enableFeedback: params.enableFeedback,
      alignment: params.alignment,
      borderRadius: params.borderRadius,
      padding: params.padding,
    );
  }
}
