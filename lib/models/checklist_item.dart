import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ChecklistItem extends Equatable {
  final String id;
  final String description;
  final DateTime targetDate;

  const ChecklistItem({
    @required this.id,
    @required this.description,
    this.targetDate,
  });

  @override
  List<Object> get props => [id];
}
