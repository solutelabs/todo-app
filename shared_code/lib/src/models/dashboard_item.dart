import 'package:equatable/equatable.dart';
import 'package:shared_code/src/models/list_mode.dart';
import 'package:meta/meta.dart';

class DashboardItem extends Equatable {
  final String title;
  final String subtitle;
  final ListMode mode;

  DashboardItem({
    @required this.title,
    @required this.subtitle,
    @required this.mode,
  });

  @override
  List<Object> get props => [title, subtitle, mode];
}
