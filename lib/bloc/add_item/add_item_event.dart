import 'package:meta/meta.dart';

@immutable
abstract class AddItemEvent {}

class DescriptionAdded extends AddItemEvent {
  final String description;

  DescriptionAdded(this.description);
}

class TargetDateSelected extends AddItemEvent {
  final DateTime targetDate;

  TargetDateSelected(this.targetDate);
}

class OnTapSave extends AddItemEvent {}
