import 'flash_field.dart';

abstract class FlashFieldEvent {}

class ListItemRemoveEvent extends FlashFieldEvent {
  final FlashField field;
  ListItemRemoveEvent(this.field);
}

class ValueChangeEvent extends FlashFieldEvent {
  final int id;
  final dynamic value;
  ValueChangeEvent({
    required this.id,
    required this.value,
  });

  @override
  String toString() {
    return 'ValueChangeEvent{id: $id, value: $value}';
  }
}
