import 'dart:ui';

import 'package:flash_form/flash_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlashTextField<T> extends StatefulWidget {
  final ValueSchema field;
  final TextFieldParameters? textFieldParams;
  const FlashTextField({
    super.key,
    required this.field,
    this.textFieldParams,
  });

  @override
  State<FlashTextField> createState() => _FlashTextFieldState();
}

class _FlashTextFieldState extends State<FlashTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    final paramController = widget.textFieldParams?.controller;
    if (paramController != null) {
      _controller = paramController;
      _controller.text = widget.field.viewValue(context) ?? '';
    } else {
      _controller = TextEditingController(
        text: widget.field.viewValue(context),
      );
    }

    _controller.addListener(_onTextChanged);
    widget.field.addListener(_onFieldChanged);
  }

  void _onTextChanged() {
    final currentText = widget.field.viewValue(context);

    if (currentText != _controller.text) {
      final value = widget.field.convertViewToValue(context, _controller.text);
      if (value != null) {
        widget.field.updateValue(value);
      }
    }
  }

  void _onFieldChanged() {
    final currentText = widget.field.viewValue(context);
    if (currentText == _controller.text) {
      return;
    }

    // 現在のカーソル位置を保持
    int cursorPosition = _controller.selection.start;

    // テキストフィールドの値を更新
    _controller.text = widget.field.viewValue(context) ?? '';

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
      focusNode: widget.field.focusNode,
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

  TextFieldParameters merge(TextFieldParameters? other) {
    return TextFieldParameters(
      key: other?.key ?? key,
      controller: other?.controller ?? controller,
      undoController: other?.undoController ?? undoController,
      decoration: other?.decoration ?? decoration,
      keyboardType: other?.keyboardType ?? keyboardType,
      textInputAction: other?.textInputAction ?? textInputAction,
      textCapitalization: other?.textCapitalization ?? textCapitalization,
      style: other?.style ?? style,
      strutStyle: other?.strutStyle ?? strutStyle,
      textAlign: other?.textAlign ?? textAlign,
      textAlignVertical: other?.textAlignVertical ?? textAlignVertical,
      textDirection: other?.textDirection ?? textDirection,
      readOnly: other?.readOnly ?? readOnly,
      showCursor: other?.showCursor ?? showCursor,
      autofocus: other?.autofocus ?? autofocus,
      statesController: other?.statesController ?? statesController,
      obscuringCharacter: other?.obscuringCharacter ?? obscuringCharacter,
      obscureText: other?.obscureText ?? obscureText,
      autocorrect: other?.autocorrect ?? autocorrect,
      smartDashesType: other?.smartDashesType ?? smartDashesType,
      smartQuotesType: other?.smartQuotesType ?? smartQuotesType,
      enableSuggestions: other?.enableSuggestions ?? enableSuggestions,
      maxLines: other?.maxLines ?? maxLines,
      minLines: other?.minLines ?? minLines,
      expands: other?.expands ?? expands,
      maxLength: other?.maxLength ?? maxLength,
      maxLengthEnforcement: other?.maxLengthEnforcement ?? maxLengthEnforcement,
      onChanged: other?.onChanged ?? onChanged,
      onEditingComplete: other?.onEditingComplete ?? onEditingComplete,
      onSubmitted: other?.onSubmitted ?? onSubmitted,
      onAppPrivateCommand: other?.onAppPrivateCommand ?? onAppPrivateCommand,
      inputFormatters: other?.inputFormatters ?? inputFormatters,
      enabled: other?.enabled ?? enabled,
      ignorePointers: other?.ignorePointers ?? ignorePointers,
      cursorWidth: other?.cursorWidth ?? cursorWidth,
      cursorHeight: other?.cursorHeight ?? cursorHeight,
      cursorRadius: other?.cursorRadius ?? cursorRadius,
      cursorOpacityAnimates:
          other?.cursorOpacityAnimates ?? cursorOpacityAnimates,
      cursorColor: other?.cursorColor ?? cursorColor,
      cursorErrorColor: other?.cursorErrorColor ?? cursorErrorColor,
      selectionHeightStyle: other?.selectionHeightStyle ?? selectionHeightStyle,
      selectionWidthStyle: other?.selectionWidthStyle ?? selectionWidthStyle,
      keyboardAppearance: other?.keyboardAppearance ?? keyboardAppearance,
      scrollPadding: other?.scrollPadding ?? scrollPadding,
      dragStartBehavior: other?.dragStartBehavior ?? dragStartBehavior,
      enableInteractiveSelection:
          other?.enableInteractiveSelection ?? enableInteractiveSelection,
      selectionControls: other?.selectionControls ?? selectionControls,
      onTap: other?.onTap ?? onTap,
      onTapAlwaysCalled: other?.onTapAlwaysCalled ?? onTapAlwaysCalled,
      onTapOutside: other?.onTapOutside ?? onTapOutside,
      mouseCursor: other?.mouseCursor ?? mouseCursor,
      buildCounter: other?.buildCounter ?? buildCounter,
      scrollController: other?.scrollController ?? scrollController,
      scrollPhysics: other?.scrollPhysics ?? scrollPhysics,
      autofillHints: other?.autofillHints ?? autofillHints,
      contentInsertionConfiguration:
          other?.contentInsertionConfiguration ?? contentInsertionConfiguration,
      clipBehavior: other?.clipBehavior ?? clipBehavior,
      restorationId: other?.restorationId ?? restorationId,
      scribbleEnabled: other?.scribbleEnabled ?? scribbleEnabled,
      enableIMEPersonalizedLearning:
          other?.enableIMEPersonalizedLearning ?? enableIMEPersonalizedLearning,
      contextMenuBuilder: other?.contextMenuBuilder ?? contextMenuBuilder,
      canRequestFocus: other?.canRequestFocus ?? canRequestFocus,
      spellCheckConfiguration:
          other?.spellCheckConfiguration ?? spellCheckConfiguration,
      magnifierConfiguration:
          other?.magnifierConfiguration ?? magnifierConfiguration,
    );
  }
}
