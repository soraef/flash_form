import 'package:flash_form/flash_form.dart';

class ValueChangeEvent extends FormEvent {
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
