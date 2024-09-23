import 'package:flash_form/flash_form.dart';

import 'models.dart';

class RootConditionForm extends ModelSchema<RootCondition> {
  RootConditionForm() : super(parent: null);

  late final conditionField = ConditionTypeField(
    parent: this,
  );

  @override
  List<FieldSchema> get fields => [conditionField];

  @override
  void fromModel(RootCondition model) {
    conditionField.updateValue(model.condition);
  }

  @override
  RootCondition toModel() {
    return RootCondition(conditionField.value!);
  }
}

class ConditionTypeField
    extends TypeSchema<ICondition, ICondition, ConditionType> {
  ConditionTypeField({
    required super.parent,
  }) : super(
          toDisplay: (context, value) => value.name,
          typeOptions: [
            ConditionType.and,
            ConditionType.or,
            ConditionType.not,
            ConditionType.equals,
            ConditionType.greaterThan,
            ConditionType.lessThan,
            ConditionType.contains,
          ],
          factory: (type, parent) {
            switch (type) {
              case ConditionType.and:
                return AndForm(parent: parent);
              case ConditionType.or:
                return OrForm(parent: parent);
              case ConditionType.not:
                return NotForm(parent: parent);
              case ConditionType.equals:
                return EqualsForm(parent: parent);
              case ConditionType.greaterThan:
                return GreaterThanForm(parent: parent);
              case ConditionType.lessThan:
                return LessThanForm(parent: parent);
              case ConditionType.contains:
                return ContainsForm(parent: parent);
              default:
                throw Exception('Invalid type');
            }
          },
          type: null,
          typeFactory: (ICondition value) => value.conditionType,
        );
}

enum ConditionType {
  root,
  and,
  or,
  not,
  equals,
  greaterThan,
  lessThan,
  contains,
}

class AndForm extends ModelSchema<And> {
  AndForm({
    required super.parent,
  }) : super();

  late final conditionsField = ListSchema<dynamic, dynamic>(
    children: [],
    childFactory: (value, parent) => ConditionTypeField(
      parent: parent,
    ),
    parent: this,
  );

  @override
  List<FieldSchema> get fields => [conditionsField];

  @override
  void fromModel(And model) {
    conditionsField.updateValue(model.conditions);
  }

  @override
  And toModel() {
    final value = conditionsField.value;
    return And(value?.whereType<ICondition>().toList() ?? []);
  }
}

class OrForm extends ModelSchema<Or> {
  OrForm({
    required super.parent,
  }) : super();

  late final conditionsField = ListSchema(
    children: [],
    parent: this,
    childFactory: (value, parent) => ConditionTypeField(
      parent: parent,
    ),
  );

  @override
  List<FieldSchema> get fields => [conditionsField];

  @override
  void fromModel(Or model) {
    conditionsField.updateValue(model.conditions);
  }

  @override
  Or toModel() {
    final value = conditionsField.value;

    return Or(value?.whereType<ICondition>().toList() ?? []);
  }
}

class NotForm extends ModelSchema<Not> {
  NotForm({
    required super.parent,
  }) : super();

  late final conditionField = ConditionTypeField(
    parent: this,
  );

  @override
  List<FieldSchema> get fields => [conditionField];

  @override
  void fromModel(Not model) {
    conditionField.updateValue(model.condition);
  }

  @override
  Not toModel() {
    return Not(conditionField.value!);
  }
}

class EqualsForm extends ModelSchema<Equals> {
  EqualsForm({
    required super.parent,
  }) : super();

  late final keyField = ValueSchema<PersonEqualsField, String>(
    fieldFormat: SelectFieldFormat(
      options: PersonEqualsField.values,
      toDisplay: (value) => value?.name,
    ),
    validators: [RequiredValidator()],
    decorators: [const DefaultValueDecorator(label: 'field')],
    parent: this,
  );

  late final valueField = ValueSchema(
    fieldFormat: TextFieldFormat(),
    validators: [RequiredValidator()],
    decorators: [const DefaultValueDecorator(label: 'value')],
    parent: this,
  );

  @override
  List<FieldSchema> get fields => [keyField, valueField];

  @override
  void fromModel(Equals model) {
    keyField.updateValue(model.fieldType);
    valueField.updateValue(model.value);
  }

  @override
  Equals toModel() {
    return Equals(keyField.value!, valueField.value!);
  }
}

class GreaterThanForm extends ModelSchema<GreaterThan> {
  GreaterThanForm({
    required super.parent,
  }) : super();

  late final keyField = ValueSchema<PersonGreaterThanField, String>(
    fieldFormat: SelectFieldFormat(
      options: PersonGreaterThanField.values,
      toDisplay: (value) => value?.name,
    ),
    parent: this,
    value: null,
  );

  late final valueField = ValueSchema(
    fieldFormat: NumberFieldFormat(),
    value: null,
    parent: this,
  );

  @override
  List<FieldSchema> get fields => [keyField, valueField];

  @override
  void fromModel(GreaterThan model) {
    keyField.updateValue(model.key);
    valueField.updateValue(model.value);
  }

  @override
  GreaterThan toModel() {
    return GreaterThan(keyField.value!, valueField.value!);
  }
}

class LessThanForm extends ModelSchema<LessThan> {
  LessThanForm({
    required super.parent,
  }) : super();

  late final keyField = ValueSchema<PersonLessThanField, String>(
    fieldFormat: SelectFieldFormat(
      options: PersonLessThanField.values,
      toDisplay: (value) => value?.name,
    ),
    parent: this,
    value: null,
  );

  late final valueField = ValueSchema(
    fieldFormat: NumberFieldFormat(),
    value: null,
    parent: this,
  );

  @override
  List<FieldSchema> get fields => [keyField, valueField];

  @override
  void fromModel(LessThan model) {
    keyField.updateValue(model.key);
    valueField.updateValue(model.value);
  }

  @override
  LessThan toModel() {
    return LessThan(keyField.value!, valueField.value!);
  }
}

class ContainsForm extends ModelSchema<Contains> {
  ContainsForm({
    required super.parent,
  }) : super();

  late final keyField = ValueSchema<PersonContainsField, String>(
    fieldFormat: SelectFieldFormat(
      options: PersonContainsField.values,
      toDisplay: (value) => value?.name,
    ),
    parent: this,
    value: null,
  );

  late final valueField = ValueSchema(
    fieldFormat: TextFieldFormat(),
    value: null,
    parent: this,
  );

  @override
  List<FieldSchema> get fields => [keyField, valueField];

  @override
  void fromModel(Contains model) {
    keyField.updateValue(model.key);
    valueField.updateValue(model.value);
  }

  @override
  Contains toModel() {
    return Contains(keyField.value!, valueField.value!);
  }
}
