import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_code/shared_code.dart';

import './bloc.dart';

class AddItemBloc extends Bloc<AddItemEvent, AddItemState> {
  final dateTimeUtils = DateTimeUtils();
  String itemDescription;
  DateTime targetDate;
  final ChecklistItemsRepository checklistItemsRepository;

  AddItemBloc({@required this.checklistItemsRepository});

  @override
  AddItemState get initialState => InitialAddItemState();

  @override
  Stream<AddItemState> mapEventToState(
    AddItemEvent event,
  ) async* {
    if (event is DescriptionAdded) {
      itemDescription = event.description;
    }

    if (event is TargetDateSelected) {
      targetDate = event.targetDate;
      yield TargetDateChanged(
        formattedDate: dateTimeUtils.formatDate(targetDate),
      );
    }

    if (event is OnTapSave) {
      yield* validateAndSaveItem();
    }
  }

  Stream<AddItemState> validateAndSaveItem() async* {
    final validationInfo = validateForm();
    final hasErrors = validationInfo['has_errors'] as bool;
    if (hasErrors) {
      final errors = validationInfo['errors'] as List<String>;
      yield AddItemFailed(error: errors.map((e) => '• $e').join('\n'));
      return;
    }
    try {
      await checklistItemsRepository.insert(
        description: itemDescription,
        targetDate: targetDate,
      );
      yield AddItemSuccess();
    } catch (_) {
      yield AddItemFailed(error: "Item could not be saved!");
    }
  }

  Map<String, dynamic> validateForm() {
    final List<String> errors = [];
    if (itemDescription == null || itemDescription.trim().isEmpty) {
      errors.add('Enter description');
    }
    return {
      'has_errors': errors.isNotEmpty,
      'errors': errors,
    };
  }
}
