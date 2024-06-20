import 'package:flash_form/flash_form.dart';

enum InsertPosition {
  above,
  below,
}

class ListItemAddEvent extends FormEvent {
  final FieldSchema field;
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
