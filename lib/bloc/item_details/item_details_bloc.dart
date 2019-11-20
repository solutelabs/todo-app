import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/utils/datetime_utils.dart';
import 'package:meta/meta.dart';

import './bloc.dart';

class ItemDetailsBloc extends Bloc<ItemDetailsEvent, ItemDetailsState> {
  final ChecklistItemsRepository checklistItemsRepository;

  ItemDetailsBloc({@required this.checklistItemsRepository});

  @override
  ItemDetailsState get initialState => InitialItemDetailsState();

  @override
  Stream<ItemDetailsState> mapEventToState(
    ItemDetailsEvent event,
  ) async* {
    if (event is FetchItemDetails) {
      yield* fetchItemDetails(event.itemId);
    }
  }

  Stream<ItemDetailsState> fetchItemDetails(String itemId) async* {
    final item = await checklistItemsRepository.getItem(itemId);
    if (item != null) {
      yield ItemDetailsAvailable(
        title: item.description,
        date: DateTimeUtils().formatDate(item.targetDate),
      );
    }
  }
}
