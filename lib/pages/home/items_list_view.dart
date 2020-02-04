import 'package:checklist/bloc/list_items/bloc.dart';
import 'package:checklist/providers/items_provider.dart';
import 'package:checklist/ui_components/checklist_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:shared_code/shared_code.dart';

class ItemsListView extends StatelessWidget {
  final ListMode listMode;
  final dateTimeUtils = DateTimeUtils();
  final void Function(String) onItemSelected;

  ItemsListView({
    Key key,
    this.listMode = ListMode.all,
    @required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = kiwi.Container();
    return BlocProvider<ListItemsBloc>(
      builder: (context) => ListItemsBloc(
        itemsProvider: c<ItemsProvider>(),
      )..add(FetchListItems(listMode)),
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 16,
                  ),
                ),
                BlocBuilder<ListItemsBloc, ListItemsState>(
                  builder: (context, state) {
                    return StreamBuilder<List<ChecklistItem>>(
                      stream: state.itemsStream,
                      builder: (context, snapshot) {
                        final items = snapshot.data;
                        if (items != null && items.length > 0) {
                          return SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              final item = items[index];
                              final subtitle = item.targetDate != null
                                  ? dateTimeUtils.formatDate(item.targetDate)
                                  : '';
                              return GestureDetector(
                                child: ChecklistCard(
                                  title: item.description,
                                  subtitle: subtitle,
                                  isCompleted: item.isCompleted,
                                  toggleCompletionStatus: () =>
                                      BlocProvider.of<ListItemsBloc>(context)
                                          .add(ToggleCompletionStatus(item)),
                                ),
                                onTap: () => onItemSelected(item.id),
                              );
                            }, childCount: items.length),
                          );
                        }
                        return SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'All done ✅',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.display2,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
