abstract class ICondition {
  final String name;

  ICondition(this.name);

  bool isSatisfied(Map<String, dynamic> data);

  @override
  String toString() {
    return name;
  }
}

class RootCondition extends ICondition {
  final ICondition condition;
  RootCondition(this.condition) : super('ROOT');

  @override
  bool isSatisfied(Map<String, dynamic> data) {
    return condition.isSatisfied(data);
  }

  @override
  String toString() {
    return condition.toString();
  }
}

class And extends ICondition {
  final List<ICondition> conditions;
  And(this.conditions) : super('AND');

  @override
  bool isSatisfied(Map<String, dynamic> data) {
    return conditions.every((condition) => condition.isSatisfied(data));
  }

  @override
  String toString() {
    return '( ${conditions.join(' AND ')} )';
  }
}

class Or extends ICondition {
  final List<ICondition> conditions;
  Or(this.conditions) : super('OR');

  @override
  bool isSatisfied(Map<String, dynamic> data) {
    return conditions.any((condition) => condition.isSatisfied(data));
  }

  @override
  String toString() {
    return '( ${conditions.join(' OR ')} )';
  }
}

class Not extends ICondition {
  final ICondition condition;
  Not(this.condition) : super('NOT');

  @override
  bool isSatisfied(Map<String, dynamic> data) {
    return !condition.isSatisfied(data);
  }

  @override
  String toString() {
    return '( NOT ${condition} )';
  }
}

class Equals extends ICondition {
  final String key;
  final dynamic value;
  Equals(this.key, this.value) : super('EQUALS');

  @override
  bool isSatisfied(Map<String, dynamic> data) {
    return data[key] == value;
  }

  @override
  String toString() {
    return 'Equals: data[$key] == $value';
  }
}

class GreaterThan extends ICondition {
  final String key;
  final dynamic value;
  GreaterThan(this.key, this.value) : super('GREATER_THAN');

  @override
  bool isSatisfied(Map<String, dynamic> data) {
    return data[key] > value;
  }
}

class LessThan extends ICondition {
  final String key;
  final dynamic value;
  LessThan(this.key, this.value) : super('LESS_THAN');

  @override
  bool isSatisfied(Map<String, dynamic> data) {
    return data[key] < value;
  }
}

class Contains extends ICondition {
  final String key;
  final dynamic value;
  Contains(this.key, this.value) : super('CONTAINS');

  @override
  bool isSatisfied(Map<String, dynamic> data) {
    return data[key].contains(value);
  }
}
