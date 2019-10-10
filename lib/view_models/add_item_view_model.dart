import 'package:checklist/repositories/checklist_items_repository.dart';
import 'package:checklist/utils/datetime_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class AddItemViewModel {
  final ChecklistItemsRepository repository;
  final dateTimeUtils = DateTimeUtils();

  final description = BehaviorSubject<String>();
  final targetDate = BehaviorSubject<DateTime>();
  final targetDateString = BehaviorSubject<String>();
  final onSaveTap = PublishSubject<void>();
  final onItemSaved = PublishSubject<void>();
  final onError = PublishSubject<String>();

  final _subscriptions = CompositeSubscription();

  AddItemViewModel({
    @required this.repository,
  }) {
    _subscriptions.add(
      targetDate
          .map((date) => dateTimeUtils.formatDate(date))
          .listen(targetDateString.add),
    );
    _subscriptions.add(
      onSaveTap.throttleTime(Duration(milliseconds: 500)).listen(
        (_) => validateAndSave(),
        onError: (err) {
          debugPrint(err.toString());
          onError.add("Item could not be saved!");
        },
      ),
    );
  }

  void dispose() {
    description.close();
    targetDate.close();
    targetDateString.close();
    onSaveTap.close();
    onItemSaved.close();
    onError.close();
    _subscriptions.dispose();
  }

  Future<void> validateAndSave() async {
    final validationInfo = validateForm();
    final hasErrors = validationInfo['has_errors'] as bool;
    if (hasErrors) {
      final errors = validationInfo['errors'] as List<String>;
      onError.add(errors.map((e) => '• $e').join('\n'));
      return;
    }
    await repository.insert(
      descritpion: description.value,
      targetDate: targetDate.value,
    );
    onItemSaved.add(null);
  }

  Map<String, dynamic> validateForm() {
    final List<String> errors = [];
    if (description.value == null || description.value.trim().isEmpty) {
      errors.add('Enter description');
    }
    return {
      'has_errors': errors.isNotEmpty,
      'errors': errors,
    };
  }
}
