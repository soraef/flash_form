import 'dart:async';
import 'dart:math';

import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';

import '../formats/color_pick_field_format.dart';

class FlashColorPickField extends StatelessWidget {
  final ValueSchema field;
  const FlashColorPickField({
    super.key,
    required this.field,
  });

  @override
  Widget build(BuildContext context) {
    final format = field.fieldFormat as ColorPickFieldFormat;
    final value = field.value as Color?;
    final colorSize = format.colorSize ?? 18;

    return GenericOverlayWidget<Color>(
      onClose: (value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print('update value');
          field.updateValue(value);
        });
      },
      overlayBuilder: (context, onClose) {
        return _ColorPickerOverlayWidget(
          colorOptions: format.colors,
          colorSize: colorSize,
          selectedColor: value ?? Colors.transparent,
          onCancel: () {
            onClose(null);
          },
          onConfirm: (color) {
            onClose(color);
          },
        );
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: 10,
                color: value,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class GenericOverlayWidget<T> extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext, void Function(T? value)) overlayBuilder;
  final VoidCallback? onOpen;
  final void Function(T? value)? onClose;

  const GenericOverlayWidget({
    Key? key,
    required this.child,
    required this.overlayBuilder,
    this.onOpen,
    this.onClose,
  }) : super(key: key);

  @override
  _GenericOverlayWidgetState<T> createState() =>
      _GenericOverlayWidgetState<T>();
}

class _GenericOverlayWidgetState<T> extends State<GenericOverlayWidget<T>> {
  final GlobalKey _actionKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    final RenderBox? renderBox =
        _actionKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size;
    final offset = renderBox?.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => _hideOverlay(null),
              behavior: HitTestBehavior.opaque,
              // child: Container(color: Colors.black.withOpacity(0.3)),
            ),
          ),
          Positioned(
            left: offset?.dx,
            top: offset?.dy,
            width: size?.width,
            child: Material(
              borderRadius: BorderRadius.circular(8),
              elevation: 2.0,
              child: widget.overlayBuilder(
                context,
                _hideOverlay,
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    widget.onOpen?.call();
  }

  void _hideOverlay(T? value) {
    print('hide overlay');
    _overlayEntry?.remove();
    _overlayEntry = null;
    widget.onClose?.call(value);
  }

  @override
  void dispose() {
    _hideOverlay(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _actionKey,
      onTap: _showOverlay,
      child: widget.child,
    );
  }
}

class _ColorPickerOverlayWidget extends StatefulWidget {
  final List<List<Color>> colorOptions;
  final Color? selectedColor;
  final VoidCallback onCancel;
  final Function(Color?) onConfirm;
  final int colorSize;

  const _ColorPickerOverlayWidget({
    Key? key,
    required this.colorOptions,
    required this.selectedColor,
    required this.onCancel,
    required this.onConfirm,
    required this.colorSize,
  }) : super(key: key);

  @override
  State<_ColorPickerOverlayWidget> createState() =>
      _ColorPickerOverlayWidgetState();
}

class _ColorPickerOverlayWidgetState extends State<_ColorPickerOverlayWidget> {
  Color? _selectedColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedColor = widget.selectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = _calculateColorSize();
          return _buildCard(context, size);
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, double colorSize) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            ..._buildColorRows(colorSize),
            // const SizedBox(height: 16),
            // _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildColorRows(double colorSize) {
    return widget.colorOptions
        .map((row) => _buildColorRow(row, colorSize))
        .toList();
  }

  Widget _buildColorRow(List<Color> colors, double colorSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children:
          colors.map((color) => _buildColorButton(color, colorSize)).toList(),
    );
  }

  Widget _buildColorButton(Color color, double colorSize) {
    return GestureDetector(
      onTap: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _selectedColor = color;
            widget.onConfirm(_selectedColor);
          });
        });
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        width: colorSize,
        height: colorSize,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: _selectedColor == color ? Colors.white : Colors.grey,
            width: _selectedColor == color ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(2),
          boxShadow: _selectedColor == color
              ? [const BoxShadow(color: Colors.black26, blurRadius: 4)]
              : null,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: widget.onCancel,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed:
              _selectedColor != null ? widget.onConfirm(_selectedColor) : null,
          child: const Text('Select'),
        ),
      ],
    );
  }

  double _calculateColorSize() {
    return widget.colorSize.toDouble();
  }
}
