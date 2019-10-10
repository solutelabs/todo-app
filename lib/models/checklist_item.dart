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
    @required this.isCompleted,
    this.targetDate,
  });

  @override
  List<Object> get props => [id];
}
