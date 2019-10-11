import 'package:flutter/material.dart';

class DashboardStatsCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const DashboardStatsCard({
    Key key,
    @required this.title,
    @required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.display3.copyWith(
                    color: Theme.of(context).cardColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(color: Theme.of(context).cardColor),
            ),
          ],
        ),
      ),
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
    );
  }
}
