import 'package:flash_form/flash_form.dart';

enum MoveType {
  up1,
  down1,
  top,
  bottom,
}

class ListItemMoveEvent extends FlashFieldEvent {
  final FlashField field;
  final MoveType moveType;
  ListItemMoveEvent({
    required this.field,
    required this.moveType,
  });
}
