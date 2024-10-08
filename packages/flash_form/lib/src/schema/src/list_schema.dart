import 'package:flash_form/flash_form.dart';
import 'package:flash_form/src/fields/src/list_field/formats/list_field_format.dart';
import 'package:flutter/material.dart';

List<FieldDecorator> defaultListDecorator(
  BuildContext context,
) {
  return [const DefaultListDecorator()];
}

class ListSchema<TValue, TView> extends FieldSchema<List<TValue>, List<TView>> {
  /// Initial List of children fields
  ///
  /// **Note**
  /// - Since the type information of the generics type disappears, required is specified.
  List<FieldSchema<TValue, TView>> children;
  String? Function(List<TValue> value)? validator;
  FieldSchema<TValue, TView> Function(
    TValue? value,
    ListSchema<TValue, TView> parent,
  )? childFactory;
  void Function(FormEvent event, ListSchema<TValue, TView>)? handleEvent;

  ListSchema({
    required super.parent,
    required this.children,
    super.decorators = defaultListDecorator,
    super.fieldFormat = const ListFieldFormat(),
    this.childFactory,
    this.validator,
  });

  @override
  void updateValue(List<TValue>? newValue) {
    children.clear();
    children.addAll(
      newValue?.map(
              (value) => childFactory!(value, this)..updateValue(value)) ??
          List.empty(),
    );
    notifyListeners();
  }

  void addField() {
    if (childFactory == null) {
      return;
    }
    final child = childFactory!(null, this);

    children.add(child);
    notifyListeners();
  }

  void insertField(int index) {
    if (childFactory == null) {
      return;
    }
    final child = childFactory!(null, this);

    children.insert(index, child);
    notifyListeners();
  }

  void removeField(FieldSchema<TValue, TView> field) {
    children.remove(field);
    context.removeId(field.id);

    notifyListeners();
  }

  void moveField(FieldSchema<TValue, TView> field, MoveType moveType) {
    final index = children.indexOf(field);
    if (index == -1) {
      return;
    }

    late int newIndex;
    if (moveType == MoveType.up1) {
      newIndex = index - 1;
    } else if (moveType == MoveType.down1) {
      newIndex = index + 1;
    } else if (moveType == MoveType.top) {
      newIndex = 0;
    } else if (moveType == MoveType.bottom) {
      newIndex = children.length - 1;
    }

    if (newIndex < 0 || newIndex >= children.length) {
      return;
    }

    children.remove(field);
    children.insert(newIndex, field);

    notifyListeners();
  }

  void _handleChildEvent(FormEvent event) {
    if (event is ListItemRemoveEvent &&
        context.isParentChild(
          childId: event.field.id,
          parentId: id,
        )) {
      removeField(event.field as FieldSchema<TValue, TView>);
    }

    if (event is ListItemAddEvent &&
        context.isParentChild(
          childId: event.field.id,
          parentId: id,
        )) {
      final index = context.indexOf(event.field.id);
      if (index == -1) {
        return;
      }

      final position = event.position;
      if (position == InsertPosition.above) {
        insertField(index);
      } else {
        insertField(index + 1);
      }
    }

    if (event is ListItemMoveEvent &&
        context.isParentChild(
          childId: event.field.id,
          parentId: id,
        )) {
      moveField(event.field as FieldSchema<TValue, TView>, event.moveType);
    }

    if (event is ListItemRemoveEvent) {}
  }

  @override
  List<TValue>? get value =>
      children.map((e) => e.value).whereType<TValue>().toList();

  @override
  void onEvent(FormEvent event) {
    super.onEvent(event);
    _handleChildEvent(event);
    handleEvent?.call(event, this);
  }

  @override
  Future<bool> validate() async {
    bool isValid = await super.validate();
    for (var child in children) {
      isValid = await child.validate() && isValid;
    }
    notifyListeners();

    return isValid;
  }

  @override
  SchemaType get fieldType => SchemaType.list;

  @override
  bool get hasFocusRecursive =>
      children.any((child) => child.hasFocusRecursive);
}
