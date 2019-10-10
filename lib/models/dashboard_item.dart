import 'package:checklist/models/list_mode.dart';
import 'package:meta/meta.dart';

class DashboardItem {
  final String title;
  final String subtitle;
  final ListMode mode;

  DashboardItem({
    @required this.title,
    @required this.subtitle,
    @required this.mode,
  });
}
