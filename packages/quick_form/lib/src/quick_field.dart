import 'package:flutter/widgets.dart';
import 'package:quick_form/src/quick_field_preview.dart';

import 'quick_field_event.dart';
import 'quick_field_format.dart';
import 'quick_form_converter.dart';

class ListItemMetadata {
  final int index;

  ListItemMetadata({
    required this.index,
  });
}

abstract class QuickField<ValueType, ViewType> with ChangeNotifier {
  final String label;
  final FieldFormat fieldFormat;

  ListItemMetadata? _listItemMetadata;
  ListItemMetadata? get listItemMetadata => _listItemMetadata;

  void Function(QuickFieldEvent event)? emitEventToParent;

  QuickField({
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

class ValueField<ValueType, ViewType> extends QuickField<ValueType, ViewType> {
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
    extends QuickField<List<ValueType>, List<ViewType>> {
  List<QuickField<ValueType, ViewType>> children;
  String? Function(List<ValueType> value)? validator;
  QuickField<ValueType, ViewType> Function(ValueType? value)? childFactory;

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

  void removeField(QuickField<ValueType, ViewType> field) {
    children.remove(field);
    children.asMap().forEach((index, child) {
      child.setListItemMetadata(ListItemMetadata(index: index));
    });
    notifyListeners();
  }

  void _handleChildEvent(QuickFieldEvent event) {
    if (event is ListItemRemoveEvent) {
      removeField(event.field as QuickField<ValueType, ViewType>);
    }
  }

  @override
  List<ValueType>? get value =>
      children.map((e) => e.value).whereType<ValueType>().toList();
}

abstract class QuickForm<T> extends QuickField<T, T> {
  QuickForm({
    required super.label,
    super.fieldFormat = const ModelFieldFormat(),
  });

  List<QuickField> get fields;

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

class TypeField<ValueType, ViewType, TypeEnum>
    extends QuickField<ValueType, ViewType> {
  final Map<TypeEnum, QuickField<ValueType, ViewType>> fields;
  final TypeEnum Function(ValueType value) typeFactory;
  TypeEnum? type;
  QuickField<ValueType, ViewType>? selectedField;

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
    selectedField = fields[type];
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
