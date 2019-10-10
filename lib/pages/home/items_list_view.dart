import 'package:checklist/models/checklist_item.dart';
import 'package:checklist/models/list_mode.dart';
import 'package:checklist/providers/items_provider.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/ui_components/checklist_card.dart';
import 'package:checklist/utils/datetime_utils.dart';
import 'package:checklist/view_models/list_items_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemsListView extends StatelessWidget {
  final ListMode listMode;
  final dateTimeUtils = DateTimeUtils();

  ItemsListView({
    this.listMode = ListMode.all,
  });

  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<ChecklistItemsRepository>(context);
    return Provider<ListItemsViewModel>(
      builder: (context) => ListItemsViewModel(
        itemsProvider: ItemsProvider(
          repository: repository,
        ),
        mode: listMode,
      ),
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
                    if (items != null) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = items[index];
                          final subtitle = item.targetDate != null
                              ? dateTimeUtils.formatDate(item.targetDate)
                              : '';
                          return ChecklistCard(
                            title: item.description,
                            subtitle: subtitle,
                            isCompleted: item.isCompleted,
                            toggleCompletionStatus: () =>
                                viewModel.toggleCompletionStatus.add(item),
                          );
                        }, childCount: items.length),
                      );
                    }
                    return SliverToBoxAdapter(
                      child: SizedBox(),
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
