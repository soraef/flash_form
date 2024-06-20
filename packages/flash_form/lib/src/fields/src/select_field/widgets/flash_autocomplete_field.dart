import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AutocompleteParameters<T> {
  final String Function(T) displayStringForOption;
  final Widget Function(
          BuildContext, TextEditingController, FocusNode, void Function())
      fieldViewBuilder;
  final void Function(T)? onSelected;
  final double optionsMaxHeight;
  final Widget Function(BuildContext, void Function(T), Iterable<T>)?
      optionsViewBuilder;
  final OptionsViewOpenDirection optionsViewOpenDirection;
  final TextEditingValue? initialValue;

  AutocompleteParameters({
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder = _defaultFieldViewBuilder,
    this.onSelected,
    this.optionsMaxHeight = 200.0,
    this.optionsViewBuilder,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.initialValue,
  });

  static Widget _defaultFieldViewBuilder(
      BuildContext context,
      TextEditingController textEditingController,
      FocusNode focusNode,
      void Function() onFieldSubmitted) {
    return TextField(
      controller: textEditingController,
      focusNode: focusNode,
      onSubmitted: (String value) => onFieldSubmitted(),
    );
  }

  factory AutocompleteParameters.forDialog({
    double? optionsMaxHeight,
    required String Function(T) displayStringForOption,
    void Function(T)? onSelected,
  }) {
    final textFieldKey = GlobalKey();

    return AutocompleteParameters(
      optionsMaxHeight: optionsMaxHeight ?? 200.0,
      displayStringForOption: displayStringForOption,
      onSelected: onSelected,
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          void Function() onFieldSubmitted) {
        return TextField(
          key: textFieldKey,
          controller: textEditingController,
          focusNode: focusNode,
          onSubmitted: (String value) => onFieldSubmitted(),
        );
      },
      optionsViewBuilder: (
        context,
        onSelected,
        options,
      ) {
        final textFieldBox =
            textFieldKey.currentContext!.findRenderObject() as RenderBox;
        final textFieldWidth = textFieldBox.size.width;
        // 入力候補リストの表示枠のWidgetを定義
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: SizedBox(
              width: textFieldWidth,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 175),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return Builder(
                      builder: (BuildContext context) {
                        final bool highlight =
                            AutocompleteHighlightedOption.of(context) == index;

                        if (highlight) {
                          SchedulerBinding.instance.addPostFrameCallback(
                            (Duration timeStamp) {
                              Scrollable.ensureVisible(context, alignment: 0.5);
                            },
                          );
                        }
                        return GestureDetector(
                          child: ListTile(
                            title: Text(
                              displayStringForOption(option),
                            ),
                          ),
                          onTap: () => onSelected(option),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FlashAutoCompleteField<T extends Object> extends StatelessWidget {
  final ValueSchema field;
  final Iterable<T> Function(String text) optionsBuilder;
  final AutocompleteParameters<T>? params;

  const FlashAutoCompleteField({
    super.key,
    required this.field,
    required this.optionsBuilder,
    this.params,
  });

  @override
  Widget build(BuildContext context) {
    final displayStringForOption = params?.displayStringForOption ??
        RawAutocomplete.defaultStringForOption;
    return Autocomplete<T>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        return optionsBuilder(textEditingValue.text);
      },
      onSelected: (option) {
        field.updateValue(option);
        params?.onSelected?.call(option);
      },
      displayStringForOption: displayStringForOption,
      fieldViewBuilder: params?.fieldViewBuilder ??
          AutocompleteParameters._defaultFieldViewBuilder,
      optionsMaxHeight: params?.optionsMaxHeight ?? 200.0,
      optionsViewBuilder: params?.optionsViewBuilder,
      optionsViewOpenDirection:
          params?.optionsViewOpenDirection ?? OptionsViewOpenDirection.down,
      initialValue: field.value != null
          ? TextEditingValue(
              text: displayStringForOption(field.value!),
            )
          : null,
    );
  }
}
