import 'package:checklist/bloc/item_details/bloc.dart';
import 'package:checklist/bloc/item_details/item_details_bloc.dart';
import 'package:shared_code/shared_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class ItemDetailsView extends StatelessWidget {
  final String id;
  final VoidCallback onClose;

  bool get isFullScreen => onClose == null;

  const ItemDetailsView({
    Key key,
    @required this.id,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = kiwi.Container();
    return Container(
      color: isFullScreen ? null : Colors.black12,
      child: BlocProvider<ItemDetailsBloc>(
        builder: (_) => ItemDetailsBloc(
          checklistItemsRepository: c<ChecklistItemsRepository>(),
        )..add(FetchItemDetails(id)),
        child: Builder(
          builder: (context) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    if (onClose != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: onClose,
                          ),
                        ],
                      ),
                    BlocBuilder<ItemDetailsBloc, ItemDetailsState>(
                      builder: (BuildContext context, state) {
                        if (state is ItemDetailsAvailable) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                state.title ?? '',
                                style: Theme.of(context).textTheme.title,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                state.date ?? '',
                                style: Theme.of(context).textTheme.subtitle,
                              )
                            ],
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
