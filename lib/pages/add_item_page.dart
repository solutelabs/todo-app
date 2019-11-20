import 'dart:async';

import 'package:checklist/bloc/add_item/add_item_bloc.dart';
import 'package:checklist/bloc/add_item/bloc.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/utils/datetime_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class AddItemPage extends StatelessWidget {
  static const routeName = '/addItem';

  @override
  Widget build(BuildContext context) {
    final c = kiwi.Container();
    return BlocProvider<AddItemBloc>(
      builder: (_) => AddItemBloc(
        checklistItemsRepository: c<ChecklistItemsRepository>(),
      ),
      child: _AddItemPageBody(),
    );
  }
}

class _AddItemPageBody extends StatefulWidget {
  @override
  __AddItemPageStateBody createState() => __AddItemPageStateBody();
}

class __AddItemPageStateBody extends State<_AddItemPageBody> {
  @override
  Widget build(BuildContext context) {
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
                BlocProvider.of<AddItemBloc>(context).add(OnTapSave());
              },
            )
          ],
        ),
        body: BlocListener<AddItemBloc, AddItemState>(
          listener: (BuildContext context, AddItemState state) {
            if (state is AddItemFailed) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state is AddItemSuccess) {
              Navigator.of(context).pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  onChanged: (text) =>
                      BlocProvider.of<AddItemBloc>(context).add(
                    DescriptionAdded(text),
                  ),
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
                Expanded(
                  child: SizedBox(),
                ),
                BlocBuilder<AddItemBloc, AddItemState>(
                  builder: (BuildContext context, AddItemState state) {
                    if (state is TargetDateChanged) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Date: ${state.formattedDate}',
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

  void dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future<void> onTapCalendar(BuildContext context) async {
    final startDate = DateTime(1900);
    final endDate = DateTime(2100);
    final date = await showDatePicker(
      context: context,
      firstDate: startDate,
      initialDate: BlocProvider.of<AddItemBloc>(context).targetDate != null
          ? BlocProvider.of<AddItemBloc>(context).targetDate
          : DateTime.now(),
      lastDate: endDate,
    );

    if (date != null) {
      final targetDate = DateTimeUtils().startOfDay(date);
      BlocProvider.of<AddItemBloc>(context).add(TargetDateSelected(targetDate));
    }
  }
}
