import 'package:meta/meta.dart';

@immutable
class ChecklistItem {
  final String id;
  final String description;
  final DateTime targetDate;

  const ChecklistItem({
    @required this.id,
    @required this.description,
    this.targetDate,
  });
}
