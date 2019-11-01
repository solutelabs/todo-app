import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/models/list_mode.dart';
import 'package:checklist/providers/viewmodel_provider.dart';
import 'package:checklist/ui_components/checklist_card.dart';
import 'package:checklist/utils/datetime_utils.dart';
import 'package:checklist/view_models/list_items_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Provider<ListItemsViewModel>(
      builder: (context) => provideListItemsViewModel(listMode),
      child: Builder(
        builder: (context) {
          final viewModel = Provider.of<ListItemsViewModel>(context);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 16,
                  ),
                ),
                StreamBuilder<List<ChecklistItem>>(
                  stream: viewModel.items,
                  builder: (context, snapshot) {
                    final items = snapshot.data;
                    if (items != null && items.length > 0) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
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
                                  viewModel.toggleCompletionStatus.add(item),
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
