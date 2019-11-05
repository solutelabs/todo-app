import 'package:flutter/material.dart';

class ChecklistCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback toggleCompletionStatus;

  const ChecklistCard({
    Key key,
    @required this.title,
    @required this.subtitle,
    @required this.isCompleted,
    @required this.toggleCompletionStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleDecoration =
        isCompleted ? TextDecoration.lineThrough : TextDecoration.none;
    final titleColor = isCompleted ? Colors.grey.shade700 : Colors.black;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                key: Key('StatusCheckBox'),
                value: isCompleted,
                onChanged: (_) => toggleCompletionStatus(),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(height: 1.1)
                          .copyWith(
                            color: titleColor,
                            decoration: titleDecoration,
                          ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(color: Colors.grey.shade500),
                      ),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


