import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

class FlashCheckboxGroupField<T> extends StatelessWidget {
  final ValueSchema<List<T>, List<String>> field;

  const FlashCheckboxGroupField({
    super.key,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    final format = field.fieldFormat as MultiSelectFieldFormat;
    final options = format.options as List<T>;
    final selected = field.value ?? [];

    return Wrap(
      children: options.map((option) {
        final value = format.toDisplayString(option);
        final isSelected = selected.contains(option);

        return InkWell(
          onTap: () {
            _onTapCheckbox(option, !isSelected);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  visualDensity: VisualDensity.compact,
                  value: isSelected,
                  onChanged: (value) {
                    _onTapCheckbox(option, value);
                  },
                ),
                Text(value),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _onTapCheckbox(T option, bool? value) {
    final selected = field.value ?? [];

    if (value == null) {
      return;
    }

    if (value == false) {
      field.updateValue(
        selected.where((e) => e != option).toSet().toList(),
      );
    } else {
      field.updateValue(
        {...selected, option}.toList(),
      );
    }
  }
}
