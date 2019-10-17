import 'package:checklist/ui_components/dashboard_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DashboardState has a title and subtitle',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        child: DashboardStatsCard(
          title: 'T',
          subtitle: 'ST',
        ),
        textDirection: TextDirection.ltr,
      ),
    );

    final titleFinder = find.text('T');
    final subTitleFinder = find.text('ST');

    expect(titleFinder, findsOneWidget);
    expect(subTitleFinder, findsOneWidget);
  });
}
