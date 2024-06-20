import 'package:flash_form/flash_form.dart';

enum InsertPosition {
  above,
  below,
}

class ListItemAddEvent extends FlashFieldEvent {
  final FlashField field;
  final InsertPosition position;
  ListItemAddEvent({
    required this.field,
    required this.position,
  });

  @override
  String toString() {
    return 'ListItemAddEvent{field: $field, position: $position}';
  }
}
