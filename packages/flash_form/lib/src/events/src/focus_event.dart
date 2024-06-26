import 'package:flash_form/flash_form.dart';

class FocusInEvent extends FormEvent {
  final int id;
  FocusInEvent({
    required this.id,
  });

  @override
  String toString() {
    return 'FocusInEvent{id: $id}';
  }
}

class FocusOutEvent extends FormEvent {
  final int id;
  FocusOutEvent({
    required this.id,
  });

  @override
  String toString() {
    return 'FocusOutEvent{id: $id}';
  }
}
