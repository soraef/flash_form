import 'flash_field.dart';

abstract class FlashFieldEvent {}

class ListItemRemoveEvent extends FlashFieldEvent {
  final FlashField field;
  ListItemRemoveEvent(this.field);
}
