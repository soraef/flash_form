import 'package:flash_form/flash_form.dart';

import 'models.dart';

class RootConditionForm extends FlashForm<RootCondition> {
  RootConditionForm() : super(label: 'Root Condition');

  final conditionField = ConditionTypeField();

  @override
  List<FlashField> get fields => [conditionField];

  @override
  void fromModel(RootCondition model) {
    conditionField.updateValue(model.condition);
  }

  @override
  RootCondition toModel() {
    return RootCondition(conditionField.value!);
  }
}

class ConditionTypeField extends TypeField<ICondition, ICondition, Type> {
  ConditionTypeField()
      : super(
          label: 'Condition Type',
          fields: {
            And: () => AndForm(),
            Or: () => OrForm(),
            Not: () => NotForm(),
            Equals: () => EqualsForm(),
          },
          type: null,
          typeFactory: (ICondition value) => value.runtimeType,
        );
}

class AndForm extends FlashForm<And> {
  AndForm() : super(label: 'And');

  final conditionsField = ListField<dynamic, dynamic>(
    label: 'Conditions',
    children: [],
    childFactory: (value) => ConditionTypeField(),
  );

  @override
  List<FlashField> get fields => [conditionsField];

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

class OrForm extends FlashForm<Or> {
  OrForm() : super(label: 'Or');

  final conditionsField = ListField(
    label: 'Conditions',
    children: [],
    childFactory: (value) => ConditionTypeField(),
  );

  @override
  List<FlashField> get fields => [conditionsField];

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

class NotForm extends FlashForm<Not> {
  NotForm() : super(label: 'Not');

  final conditionField = ConditionTypeField();

  @override
  List<FlashField> get fields => [conditionField];

  @override
  void fromModel(Not model) {
    conditionField.updateValue(model.condition);
  }

  @override
  Not toModel() {
    return Not(conditionField.value!);
  }
}

class EqualsForm extends FlashForm<Equals> {
  EqualsForm() : super(label: 'Equals');

  final keyField = ValueField<String, String>(
    label: 'Key',
    fieldFormat: TextFieldFormat(),
    value: null,
  );

  final valueField = ValueField<dynamic, dynamic>(
    label: 'Value',
    fieldFormat: TextFieldFormat(),
    value: null,
  );

  @override
  List<FlashField> get fields => [keyField, valueField];

  @override
  void fromModel(Equals model) {
    keyField.updateValue(model.key);
    valueField.updateValue(model.value);
  }

  @override
  Equals toModel() {
    return Equals(keyField.value!, valueField.value!);
  }
}
