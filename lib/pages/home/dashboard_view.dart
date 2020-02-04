import 'package:checklist/bloc/dashboard_items/bloc.dart';
import 'package:checklist/bloc/dashboard_items/dashboard_items_bloc.dart';
import 'package:checklist/mixins/ui_traits_mixin.dart';
import 'package:shared_code/shared_code.dart';
import 'package:checklist/providers/items_provider.dart';
import 'package:checklist/ui_components/dashboard_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class DashboardView extends StatelessWidget with UITraitsMixin {
  final void Function(ListMode) onModeSelected;

  DashboardView({
    Key key,
    @required this.onModeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = kiwi.Container();
    final traits = deriveWidthTrait(context);
    return BlocProvider<DashboardItemsBloc>(
      builder: (context) => DashboardItemsBloc(
        itemsProvider: c<ItemsProvider>(),
      )..add(FetchDashBoardItems()),
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
                BlocBuilder<DashboardItemsBloc, DashboardItemsState>(
                  builder: (context, state) {
                    return StreamBuilder<List<DashboardItem>>(
                      stream: state.itemsStream,
                      builder: (context, snapshot) {
                        final items = snapshot.data;
                        if (items != null) {
                          SliverGridDelegate delegate;
                          switch (traits) {
                            case UITrait.compact:
                              delegate =
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 192,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                              );
                              break;
                            case UITrait.regular:
                              delegate =
                                  SliverGridDelegateWithFixedCrossAxisCount(
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
