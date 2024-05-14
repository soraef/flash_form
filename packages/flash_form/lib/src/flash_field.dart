import 'package:flutter/widgets.dart';

import 'flash_field_event.dart';
import 'flash_field_format.dart';

class ListItemMetadata {
  final int index;

  ListItemMetadata({
    required this.index,
  });
}

abstract class FlashField<ValueType, ViewType> with ChangeNotifier {
  final String label;
  final FieldFormat fieldFormat;

  ListItemMetadata? _listItemMetadata;
  ListItemMetadata? get listItemMetadata => _listItemMetadata;

  void Function(FlashFieldEvent event)? emitEventToParent;

  FlashField({
    required this.label,
    required this.fieldFormat,
    this.emitEventToParent,
  });

  ValueType? get value;

  void updateValue(ValueType? newValue);

  void setListItemMetadata(ListItemMetadata? metadata) {
    if (_listItemMetadata != metadata) {
      _listItemMetadata = metadata;
      notifyListeners();
    }
  }
}

class ValueField<ValueType, ViewType> extends FlashField<ValueType, ViewType> {
  @override
  ValueType? value;
  String? Function(ValueType value)? validator;

  ValueField({
    required super.label,
    required ValueFieldFormat<ValueType, ViewType> super.fieldFormat,
    required this.value,
    this.validator,
  });

  @override
  void updateValue(ValueType? newValue) {
    value = newValue;
    notifyListeners();
  }

  ViewType? get viewValue => (fieldFormat as ValueFieldFormat).toView(value);
  ValueType? convertViewToValue(ViewType? viewValue) {
    return (fieldFormat as ValueFieldFormat).fromView(viewValue);
  }
}

class ListField<ValueType, ViewType>
    extends FlashField<List<ValueType>, List<ViewType>> {
  List<FlashField<ValueType, ViewType>> children;
  String? Function(List<ValueType> value)? validator;
  FlashField<ValueType, ViewType> Function(ValueType? value)? childFactory;

  ListField({
    required super.label,
    super.fieldFormat = const ListFieldFormat(),
    required this.children,
    this.childFactory,
    this.validator,
  }) {
    for (var child in children) {
      child.emitEventToParent = _handleChildEvent;
    }
  }

  @override
  void updateValue(List<ValueType>? newValue) {
    children.clear();
    children
        .addAll(newValue?.map((value) => childFactory!(value)) ?? List.empty());
    notifyListeners();
  }

  void addField() {
    if (childFactory == null) {
      return;
    }
    final child = childFactory!(null);
    child.emitEventToParent = _handleChildEvent;
    child.setListItemMetadata(ListItemMetadata(index: children.length));

    children.add(child);
    notifyListeners();
  }

  void removeField(FlashField<ValueType, ViewType> field) {
    children.remove(field);
    children.asMap().forEach((index, child) {
      child.setListItemMetadata(ListItemMetadata(index: index));
    });
    notifyListeners();
  }

  void _handleChildEvent(FlashFieldEvent event) {
    if (event is ListItemRemoveEvent) {
      removeField(event.field as FlashField<ValueType, ViewType>);
    }
  }

  @override
  List<ValueType>? get value =>
      children.map((e) => e.value).whereType<ValueType>().toList();
}

abstract class FlashForm<T> extends FlashField<T, T> {
  FlashForm({
    required super.label,
    super.fieldFormat = const ModelFieldFormat(),
  });

  List<FlashField> get fields;

  T toModel();
  void fromModel(T model);

  @override
  T? get value => toModel();

  @override
  void updateValue(T? newValue) {
    if (newValue == null) {
      return;
    }
    fromModel(newValue);
  }
}

typedef FieldFactory<ValueType, ViewType> = FlashField<ValueType, ViewType>
    Function();

class TypeField<ValueType, ViewType, TypeEnum>
    extends FlashField<ValueType, ViewType> {
  final Map<TypeEnum, FieldFactory<ValueType, ViewType>> fields;
  final TypeEnum Function(ValueType value) typeFactory;
  TypeEnum? type;
  FlashField<ValueType, ViewType>? selectedField;

  TypeField({
    required super.label,
    super.fieldFormat = const TypeFieldFormat(),
    required this.typeFactory,
    required this.fields,
    required this.type,
  });

  @override
  ValueType? get value => selectedField?.value;

  FieldFormat? get selectedFieldFormat {
    return selectedField?.fieldFormat;
  }

  void updateType(TypeEnum? newValue) {
    type = newValue;
    selectedField = fields[type]?.call();
    notifyListeners();
  }

  @override
  void updateValue(ValueType? newValue) {
    if (newValue == null) {
      type = null;
      selectedField = null;
      notifyListeners();
      return;
    }

    type = typeFactory(newValue);
    selectedField?.updateValue(newValue);
    notifyListeners();
  }
}
