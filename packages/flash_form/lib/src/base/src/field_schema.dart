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
  List<FieldDecorator>? decorators;
  List<FieldValidator> validators;
  List<ValidatorResult> validatorResults = [];
  final FocusNode focusNode = FocusNode();

  StreamSubscription<FormEvent>? _eventSubscription;

  FieldSchema({
    required this.fieldFormat,
    required this.parent,
    this.validators = const [],
    this.decorators,
  }) {
    context = parent?.context ?? FormContext();
    id = context.generateId();
    context.registerId(
      id: id,
      parentId: parent?.id,
      schema: this,
    );
    _eventSubscription = context.eventStream.listen((event) {
      onEvent(event);
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        sendEvent(FocusInEvent(id: id));
      } else {
        sendEvent(FocusOutEvent(id: id));
      }
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
        var field = fieldFormat.createFieldWidget(context, this);
        for (var decorator
            in decorators?.reversed ?? <FieldDecorator<dynamic, dynamic>>[]) {
          field = decorator.build(field, this);
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

  FieldSchema<T, S>? getSchemaById<T, S>(int id) {
    return context.getSchemaById<T, S>(id);
  }

  void forcus() {
    focusNode.requestFocus();
  }

  void unfocus() {
    focusNode.unfocus();
  }

  bool get hasFocus => focusNode.hasFocus;

  bool get hasFocusRecursive;

  @override
  void dispose() {
    _eventSubscription?.cancel();
    context.removeId(id);
    focusNode.dispose();
    super.dispose();
  }
}
