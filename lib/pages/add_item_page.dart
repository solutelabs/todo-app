import 'dart:async';

import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/ui_components/snack_message_widget.dart';
import 'package:checklist/utils/datetime_utils.dart';
import 'package:checklist/view_models/add_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddItemPage extends StatelessWidget {
  static const routeName = '/addItem';

  @override
  Widget build(BuildContext context) {
    return Provider<AddItemViewModel>(
      builder: (_) => AddItemViewModel(
        repository: Provider.of<ChecklistItemsRepository>(context),
      ),
      dispose: (_, bloc) => bloc.dispose(),
      child: Builder(
        builder: (_) => _AddItemPageBody(),
      ),
    );
  }
}

class _AddItemPageBody extends StatefulWidget {
  @override
  __AddItemPageStateBody createState() => __AddItemPageStateBody();
}

class __AddItemPageStateBody extends State<_AddItemPageBody> {
  StreamSubscription _onItemSavedSubscription;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onItemSavedSubscription ??= Provider.of<AddItemViewModel>(context)
          .onItemSaved
          .listen((_) => Navigator.of(context).pop());
    });
    super.initState();
  }

  @override
  void dispose() {
    _onItemSavedSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AddItemViewModel>(context);
    return GestureDetector(
      onTap: dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Task'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                dismissKeyboard();
                viewModel.onSaveTap.add(null);
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SnackMessageWidget(
                messageStream: viewModel.onError,
              ),
              Expanded(
                child: TextField(
                  onChanged: (text) => viewModel.description.add(text),
                  style: Theme.of(context).textTheme.title,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Enter task',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.grey.shade400),
                  ),
                ),
              ),
              StreamBuilder<String>(
                stream: viewModel.targetDateString,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Date: ${snapshot.data}',
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    );
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.calendar_today),
          onPressed: () async {
            dismissKeyboard();
            await onTapCalendar(context);
          },
        ),
      ),
    );
  }

  Future<void> onTapCalendar(BuildContext context) async {
    final startDate = DateTime(1900);
    final endDate = DateTime(2100);
    final viewModel = Provider.of<AddItemViewModel>(context);
    final date = await showDatePicker(
      context: context,
      firstDate: startDate,
      initialDate: viewModel.targetDate.hasValue
          ? viewModel.targetDate.value
          : DateTime.now(),
      lastDate: endDate,
    );

    if (date != null) {
      final viewModel = Provider.of<AddItemViewModel>(context);
      final targetDate = DateTimeUtils().startOfDay(date);
      viewModel.targetDate.add(targetDate);
    }
  }

  void dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
