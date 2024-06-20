import 'package:flash_form/flash_form.dart';

enum MoveType {
  up1,
  down1,
  top,
  bottom,
}

class ListItemMoveEvent extends FormEvent {
  final FieldSchema field;
  final MoveType moveType;
  ListItemMoveEvent({
    required this.field,
    required this.moveType,
  });
}
