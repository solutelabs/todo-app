import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AddItemState extends Equatable {}

class InitialAddItemState extends AddItemState {
  @override
  List<Object> get props => [];
}

class TargetDateChanged extends AddItemState {
  final String formattedDate;

  TargetDateChanged({@required this.formattedDate});

  @override
  List<Object> get props => [formattedDate];
}

class AddItemSuccess extends AddItemState {
  @override
  List<Object> get props => [];
}

class AddItemFailed extends AddItemState {
  final String error;

  AddItemFailed({@required this.error});

  @override
  List<Object> get props => [error];
}
