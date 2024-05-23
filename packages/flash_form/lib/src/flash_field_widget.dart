import 'dart:ui';

import 'package:flash_form/flash_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FlashFormWidget extends StatelessWidget {
  final ObjectField form;
  const FlashFormWidget({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: form.fields.map((field) => field.build()).toList(),
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
    print(
      'didUpdateWidget ${oldWidget.field} ${widget.field} ${oldWidget.field == widget.field}',
    );

    if (oldWidget.field != widget.field) {
      oldWidget.field.removeListener(_updateValue);
      widget.field.addListener(_updateValue);
    }
  }

  void _updateValue() {
    setState(() {
      print(
          'state ${widget.field.fieldFormat}: ${widget.field.validatorResults}');
    });
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

class FlashFormTextField<T> extends StatefulWidget {
  final ValueField field;
  final TextFieldParameters? textFieldParams;
  const FlashFormTextField({
    super.key,
    required this.field,
    this.textFieldParams,
  });

  @override
  State<FlashFormTextField> createState() => _FlashFormTextFieldState();
}

class _FlashFormTextFieldState extends State<FlashFormTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.field.viewValue);
    _controller.addListener(_onTextChanged);
    widget.field.addListener(_onFieldChanged);
  }

  void _onTextChanged() {
    final currentText = widget.field.viewValue ?? '';

    if (currentText != _controller.text) {
      widget.field.updateValue(
        widget.field.convertViewToValue(_controller.text),
      );
    }
  }

  void _onFieldChanged() {
    final currentText = widget.field.viewValue;
    if (currentText == _controller.text) {
      return;
    }

    // 現在のカーソル位置を保持
    int cursorPosition = _controller.selection.start;

    // テキストフィールドの値を更新
    _controller.text = widget.field.viewValue ?? '';

    // カーソル位置を復元
    if (cursorPosition >= 0 && cursorPosition <= _controller.text.length) {
      _controller.selection = TextSelection.collapsed(offset: cursorPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    final params = widget.textFieldParams ?? TextFieldParameters();
    return TextField(
      key: widget.key,
      controller: _controller,
      focusNode: params.focusNode,
      undoController: params.undoController,
      decoration: params.decoration,
      keyboardType: params.keyboardType,
      textInputAction: params.textInputAction,
      textCapitalization: params.textCapitalization,
      style: params.style,
      strutStyle: params.strutStyle,
      textAlign: params.textAlign,
      textAlignVertical: params.textAlignVertical,
      textDirection: params.textDirection,
      readOnly: params.readOnly,
      showCursor: params.showCursor,
      autofocus: params.autofocus,
      statesController: params.statesController,
      obscuringCharacter: params.obscuringCharacter,
      obscureText: params.obscureText,
      autocorrect: params.autocorrect,
      smartDashesType: params.smartDashesType,
      smartQuotesType: params.smartQuotesType,
      enableSuggestions: params.enableSuggestions,
      maxLines: params.maxLines,
      minLines: params.minLines,
      expands: params.expands,
      maxLength: params.maxLength,
      maxLengthEnforcement: params.maxLengthEnforcement,
      onChanged: params.onChanged,
      onEditingComplete: params.onEditingComplete,
      onSubmitted: params.onSubmitted,
      onAppPrivateCommand: params.onAppPrivateCommand,
      inputFormatters: params.inputFormatters,
      enabled: params.enabled,
      cursorWidth: params.cursorWidth,
      cursorHeight: params.cursorHeight,
      cursorRadius: params.cursorRadius,
      cursorOpacityAnimates: params.cursorOpacityAnimates,
      cursorColor: params.cursorColor,
      cursorErrorColor: params.cursorErrorColor,
      selectionHeightStyle: params.selectionHeightStyle,
      selectionWidthStyle: params.selectionWidthStyle,
      keyboardAppearance: params.keyboardAppearance,
      scrollPadding: params.scrollPadding,
      dragStartBehavior: params.dragStartBehavior,
      enableInteractiveSelection: params.enableInteractiveSelection,
      selectionControls: params.selectionControls,
      onTap: params.onTap,
      onTapAlwaysCalled: params.onTapAlwaysCalled,
      onTapOutside: params.onTapOutside,
      mouseCursor: params.mouseCursor,
      buildCounter: params.buildCounter,
      scrollController: params.scrollController,
      scrollPhysics: params.scrollPhysics,
      autofillHints: params.autofillHints,
      contentInsertionConfiguration: params.contentInsertionConfiguration,
      clipBehavior: params.clipBehavior,
      restorationId: params.restorationId,
      scribbleEnabled: params.scribbleEnabled,
      enableIMEPersonalizedLearning: params.enableIMEPersonalizedLearning,
      contextMenuBuilder: params.contextMenuBuilder,
      canRequestFocus: params.canRequestFocus,
      spellCheckConfiguration: params.spellCheckConfiguration,
      magnifierConfiguration: params.magnifierConfiguration,
    );
  }
}

class TextFieldParameters {
  final Key? key;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final UndoHistoryController? undoController;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool readOnly;
  final bool? showCursor;
  final bool autofocus;
  final MaterialStatesController? statesController;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final int? maxLines;
  final int? minLines;
  final bool expands;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final void Function(String, Map<String, dynamic>)? onAppPrivateCommand;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final bool? ignorePointers;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final bool? cursorOpacityAnimates;
  final Color? cursorColor;
  final Color? cursorErrorColor;
  final BoxHeightStyle selectionHeightStyle;
  final BoxWidthStyle selectionWidthStyle;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final DragStartBehavior dragStartBehavior;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final void Function()? onTap;
  final bool onTapAlwaysCalled;
  final void Function(PointerDownEvent)? onTapOutside;
  final MouseCursor? mouseCursor;
  final Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })? buildCounter;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final Clip clipBehavior;
  final String? restorationId;
  final bool scribbleEnabled;
  final bool enableIMEPersonalizedLearning;
  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;
  final bool canRequestFocus;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final TextMagnifierConfiguration? magnifierConfiguration;

  TextFieldParameters({
    this.key,
    this.controller,
    this.focusNode,
    this.undoController,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.statesController,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onAppPrivateCommand,
    this.inputFormatters,
    this.enabled,
    this.ignorePointers,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorOpacityAnimates,
    this.cursorColor,
    this.cursorErrorColor,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.selectionControls,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.autofillHints = const <String>[],
    this.contentInsertionConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scribbleEnabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.contextMenuBuilder,
    this.canRequestFocus = true,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
  });
}

class DropdownParameters<T> {
  final Key? key;

  final List<Widget> Function(BuildContext)? selectedItemBuilder;

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

class FlashFormDropdown<T> extends StatelessWidget {
  final ValueField field;
  final DropdownParameters? dropdownParams;

  const FlashFormDropdown({
    super.key,
    required this.field,
    this.dropdownParams,
  });

  @override
  Widget build(BuildContext context) {
    final format = field.fieldFormat as DropdownFieldFormat<T>;
    final params = dropdownParams ?? DropdownParameters();
    return DropdownButtonFormField(
      value: field.value,
      items: [
        for (var option in format.options)
          DropdownMenuItem(
            value: option,
            child: Text(format.toView(option) ?? ''),
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
        return Row(
          children: [
            const Spacer(),
            OutlinedButton(
              onPressed: () {
                field.addField();
              },
              child: const Text('Add'),
            ),
          ],
        );
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
