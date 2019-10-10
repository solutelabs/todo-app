import 'package:flutter/material.dart';

class AddItemPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Task'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => null,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: TextField(
                style: Theme.of(context).textTheme.title,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                  hintText: 'Enter task descriotion...',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.grey.shade400),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.calendar_today),
        onPressed: () => onTapCalendar(context),
      ),
    );
  }

  Future<void> onTapCalendar(BuildContext context) async {
    final startDate = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: startDate,
      initialDate: startDate,
      lastDate: startDate.add(Duration(days: 365)),
    );

    if (date != null) {
      // TODO:
    }
  }
}
