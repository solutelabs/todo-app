import 'package:checklist/ui_components/checklist_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CheckListCard has a title and subtitle',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        child: ChecklistCard(
          title: 'T',
          subtitle: 'ST',
          isCompleted: false,
          toggleCompletionStatus: () {},
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
