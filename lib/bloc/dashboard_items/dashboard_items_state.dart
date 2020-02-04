import 'package:shared_code/shared_code.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardItemsState extends Equatable {
  final Stream<List<DashboardItem>> itemsStream;

  DashboardItemsState(this.itemsStream);
}

class InitialDashboardItemsState extends DashboardItemsState {
  InitialDashboardItemsState() : super(Stream.empty());

  @override
  List<Object> get props => [];
}

class AvailableDashBoardItems extends DashboardItemsState {
  AvailableDashBoardItems(Stream<List<DashboardItem>> itemsStream)
      : super(itemsStream);

  @override
  List<Object> get props => [];
}
