import 'dart:async';

import 'package:flash_form/flash_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum SchemaType {
  value,
  list,
  type,
  model,
}

abstract class FieldSchema<TValue, TView>
    with ChangeNotifier
    implements FieldLayout {
  late final int id;

  final FieldFormat fieldFormat;
  final FieldSchema? parent;
  late final FormContext context;
  List<FieldDecorator>? wrappers;
  List<FieldValidator> validators;
  List<ValidatorResult> validatorResults = [];

  StreamSubscription<FormEvent>? _eventSubscription;

  FieldSchema({
    required this.fieldFormat,
    required this.parent,
    this.validators = const [],
    this.wrappers,
  }) {
    context = parent?.context ?? FormContext();
    id = context.generateId();
    context.registerId(id: id, parentId: parent?.id, type: fieldType);
    _eventSubscription = context.eventStream.listen((event) {
      onEvent(event);
    });
  }

  TValue? get value;

  void updateValue(TValue? newValue);

  bool get isListItem => context.isListItem(id);

  SchemaType get fieldType;

  @override
  Widget build() {
    return FieldBuilder(
      field: this,
      builder: (context) {
        var field = fieldFormat.createFieldWidget(this);
        for (var wrapper in wrappers ?? <FieldDecorator<dynamic, dynamic>>[]) {
          field = wrapper.build(field, this);
        }
        return field;
      },
    );
  }

  Future<bool> validate() async {
    validatorResults = await validators.validate(this);
    notifyListeners();

    return validatorResults.isEmpty;
  }

  void clearValidation() {
    validatorResults = [];
    notifyListeners();
  }

  void onEvent(FormEvent event) {}

  void sendEvent(FormEvent event) {
    context.sendEvent(event);
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    context.removeId(id);
    super.dispose();
  }
}
