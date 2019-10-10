import 'package:checklist/models/dashboard_item.dart';
import 'package:checklist/pages/items_list_page.dart';
import 'package:checklist/providers/items_provider.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/ui_components/dashboard_stats_card.dart';
import 'package:checklist/view_models/dashboard_items_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repository = Provider.of<ChecklistItemsRepository>(context);
    return Provider<DashboardItemsViewModel>(
      builder: (context) => DashboardItemsViewModel(
        itemsProvider: ItemsProvider(
          repository: repository,
        ),
      ),
      child: Builder(
        builder: (context) {
          final viewModel = Provider.of<DashboardItemsViewModel>(context);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 16,
                  ),
                ),
                StreamBuilder<List<DashboardItem>>(
                  stream: viewModel.items,
                  builder: (context, snapshot) {
                    final items = snapshot.data;
                    if (items != null) {
                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 192,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final item = items[index];
                            return GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed(
                                ItemsListPage.routeName,
                                arguments: item.mode,
                              ),
                              child: DashboardStatsCard(
                                title: item.title,
                                subtitle: item.subtitle,
                              ),
                            );
                          },
                          childCount: items.length,
                        ),
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
