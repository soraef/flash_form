import 'package:flash_form/flash_form.dart';

class ListItemRemoveEvent extends FormEvent {
  final FieldSchema field;
  ListItemRemoveEvent(this.field);
}
