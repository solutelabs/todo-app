import 'package:checklist/mixins/ui_traits_mixin.dart';
import 'package:checklist/models/dashboard_item.dart';
import 'package:checklist/models/list_mode.dart';
import 'package:checklist/providers/viewmodel_provider.dart';
import 'package:checklist/ui_components/dashboard_stats_card.dart';
import 'package:checklist/view_models/dashboard_items_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget with UITraitsMixin {
  final void Function(ListMode) onModeSelected;

  DashboardView({
    Key key,
    @required this.onModeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final traits = deriveWidthTrait(context);
    return Provider<DashboardItemsViewModel>(
      builder: (context) => provideDashboardItemsViewModel(),
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
                      SliverGridDelegate delegate;
                      switch (traits) {
                        case UITrait.compact:
                          delegate = SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 192,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          );
                          break;
                        case UITrait.regular:
                          delegate = SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          );
                          break;
                      }
                      return SliverGrid(
                        gridDelegate: delegate,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final item = items[index];
                            return GestureDetector(
                              onTap: () {
                                if (onModeSelected != null) {
                                  onModeSelected(item.mode);
                                }
                              },
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
