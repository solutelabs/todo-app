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

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
        id: json["id"],
        description: json["description"],
        targetDate: DateTime.tryParse(json["target_date"] ?? ''),
        isCompleted: json["is_completed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "target_date": targetDate != null ? targetDate.toIso8601String() : null,
        "is_completed": isCompleted,
      };
}
