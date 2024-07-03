import 'package:flash_form/flash_form.dart';

typedef SchemaFactory<TValue, TView, TOption> = FieldSchema<TValue, TView>?
    Function(
  TOption? value,
  TypeSchema parent,
);

typedef TypeFactory<TValue, TOption> = TOption Function(TValue value);

typedef TypeSchemaEventHandler<TValue, TView, TOption> = void Function(
  FormEvent event,
  TypeSchema<TValue, TView, TOption> parent,
);

class TypeSchema<TValue, TView, TOption> extends FieldSchema<TValue, TView> {
  final SchemaFactory<TValue, TView, TOption> factory;
  final TypeFactory<TValue, TOption> typeFactory;
  final List<TOption> typeOptions;
  final String Function(TOption value) toDisplay;
  TOption? type;
  FieldSchema<TValue, TView>? selectedField;
  TypeSchemaEventHandler<TValue, TView, TOption>? handleEvent;

  TypeSchema({
    super.decorators = const [DefaultTypeDecorator()],
    super.fieldFormat = const TypeFieldFormat(),
    required this.typeOptions,
    required this.typeFactory,
    required this.factory,
    required super.parent,
    required this.toDisplay,
    this.handleEvent,
    this.type,
  }) : super() {
    updateType(type);
  }

  @override
  TValue? get value => selectedField?.value;

  FieldFormat? get selectedFieldFormat {
    return selectedField?.fieldFormat;
  }

  void updateType(TOption? newValue) {
    type = newValue;
    final oldSelected = selectedField;
    if (oldSelected != null) {
      context.removeId(oldSelected.id);
    }

    selectedField = factory(type, this);

    notifyListeners();
  }

  @override
  void updateValue(TValue? newValue) {
    if (newValue == null) {
      type = null;
      selectedField = null;
      notifyListeners();
      return;
    }

    type = typeFactory(newValue);
    selectedField = factory(type, this);
    selectedField?.updateValue(newValue);
    notifyListeners();
  }

  @override
  void onEvent(FormEvent event) {
    super.onEvent(event);
    handleEvent?.call(event, this);
  }

  @override
  Future<bool> validate() async {
    bool isValid = await super.validate();
    if (selectedField != null) {
      isValid = await selectedField!.validate() && isValid;
    }
    notifyListeners();

    return isValid;
  }

  @override
  SchemaType get fieldType => SchemaType.type;

  String displayOption(TOption value) => toDisplay(value);

  /// typeによって等値性を判定して、==演算子をオーバーライドする
  @override
  bool operator ==(Object other) {
    if (other is TypeSchema) {
      return type == other.type && id == other.id;
    }
    return false;
  }

  @override
  int get hashCode => type.hashCode ^ id.hashCode;

  @override
  bool get hasFocusRecursive => selectedField?.hasFocusRecursive ?? hasFocus;
}
