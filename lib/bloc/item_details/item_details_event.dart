import 'package:meta/meta.dart';

@immutable
abstract class ItemDetailsEvent {}

class FetchItemDetails extends ItemDetailsEvent {
  final String itemId;

  FetchItemDetails(this.itemId);
}
