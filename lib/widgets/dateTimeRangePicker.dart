import 'package:flutter/material.dart';

dateTimeRangePicker(
    BuildContext context, DateTime dateTimeStart, DateTime dateTimeEnd) async {
  DateTimeRange dateTimeRange = await showDateRangePicker(
    context: context,
    initialEntryMode: DatePickerEntryMode.input,
    firstDate: DateTime(DateTime.now().year - 50),
    lastDate: DateTime(DateTime.now().year + 50),
    initialDateRange: DateTimeRange(
      end: dateTimeEnd ??
          DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day + 13),
      start: dateTimeStart ?? DateTime.now(),
    ),
  );

  return dateTimeRange;
}
