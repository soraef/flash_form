import 'package:search_query_form/form_models.dart';
import 'package:search_query_form/person.dart';

abstract class ICondition {
  final String name;

  ICondition(this.name);

  bool isSatisfied(Person data);

  @override
  String toString() {
    return name;
  }

  ConditionType get conditionType;
}

class RootCondition extends ICondition {
  final ICondition condition;
  RootCondition(this.condition) : super('ROOT');

  @override
  bool isSatisfied(Person data) {
    return condition.isSatisfied(data);
  }

  @override
  String toString() {
    return condition.toString();
  }

  @override
  ConditionType get conditionType => ConditionType.root;
}

class And extends ICondition {
  final List<ICondition> conditions;
  And(this.conditions) : super('AND');

  @override
  bool isSatisfied(Person data) {
    return conditions.every((condition) => condition.isSatisfied(data));
  }

  @override
  String toString() {
    return '( ${conditions.join(' AND ')} )';
  }

  @override
  ConditionType get conditionType => ConditionType.and;
}

class Or extends ICondition {
  final List<ICondition> conditions;
  Or(this.conditions) : super('OR');

  @override
  bool isSatisfied(Person data) {
    return conditions.any((condition) => condition.isSatisfied(data));
  }

  @override
  String toString() {
    return '( ${conditions.join(' OR ')} )';
  }

  @override
  ConditionType get conditionType => ConditionType.or;
}

class Not extends ICondition {
  final ICondition condition;
  Not(this.condition) : super('NOT');

  @override
  bool isSatisfied(Person data) {
    return !condition.isSatisfied(data);
  }

  @override
  String toString() {
    return '( NOT $condition )';
  }

  @override
  ConditionType get conditionType => ConditionType.not;
}

enum PersonEqualsField { firstname, lastname, age }

class Equals extends ICondition {
  final PersonEqualsField fieldType;
  final dynamic value;
  Equals(this.fieldType, this.value) : super('EQUALS');

  @override
  bool isSatisfied(Person data) {
    switch (fieldType) {
      case PersonEqualsField.firstname:
        return data.firstname == value;
      case PersonEqualsField.lastname:
        return data.lastname == value;
      case PersonEqualsField.age:
        return data.age == int.tryParse(value);
    }
  }

  @override
  String toString() {
    return '(person.$fieldType == $value)';
  }

  @override
  ConditionType get conditionType => ConditionType.equals;
}

enum PersonGreaterThanField { age }

class GreaterThan extends ICondition {
  final PersonGreaterThanField key;
  final dynamic value;
  GreaterThan(this.key, this.value) : super('GREATER_THAN');

  @override
  bool isSatisfied(Person data) {
    return data.age > value;
  }

  @override
  ConditionType get conditionType => throw UnimplementedError();
}

enum PersonLessThanField { age }

class LessThan extends ICondition {
  final PersonLessThanField key;
  final dynamic value;
  LessThan(this.key, this.value) : super('LESS_THAN');

  @override
  bool isSatisfied(Person data) {
    return data.age < value;
  }

  @override
  ConditionType get conditionType => throw UnimplementedError();
}

enum PersonContainsField { firstname, lastname, hobby }

class Contains extends ICondition {
  final PersonContainsField key;
  final dynamic value;
  Contains(this.key, this.value) : super('CONTAINS');

  @override
  bool isSatisfied(Person data) {
    switch (key) {
      case PersonContainsField.firstname:
        return data.firstname.contains(value);
      case PersonContainsField.lastname:
        return data.lastname.contains(value);
      case PersonContainsField.hobby:
        return data.hobbies.contains(value);
    }
  }

  @override
  ConditionType get conditionType => throw UnimplementedError();
}
