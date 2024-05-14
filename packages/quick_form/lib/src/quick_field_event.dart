import 'quick_field.dart';

abstract class QuickFieldEvent {}

class ListItemRemoveEvent extends QuickFieldEvent {
  final QuickField field;
  ListItemRemoveEvent(this.field);
}
