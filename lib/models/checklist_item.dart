import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ChecklistItem extends Equatable {
  final String id;
  final String description;
  final DateTime targetDate;
  final bool isCompleted;

  const ChecklistItem({
    @required this.id,
    @required this.description,
    this.isCompleted = false,
    this.targetDate,
  });

  @override
  List<Object> get props => [id];
}
