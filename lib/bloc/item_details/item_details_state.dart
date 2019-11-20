import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ItemDetailsState extends Equatable {}

class InitialItemDetailsState extends ItemDetailsState {
  @override
  List<Object> get props => [];
}

class ItemDetailsAvailable extends ItemDetailsState {
  final String title;
  final String date;

  ItemDetailsAvailable({@required this.title, @required this.date});

  @override
  List<Object> get props => [title, date];
}
