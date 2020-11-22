import 'package:flutter/material.dart';

dateTimeRangePicker(BuildContext context) async {
  DateTimeRange dateTimeRange = await showDateRangePicker(
    context: context,
    initialEntryMode: DatePickerEntryMode.input,
    firstDate: DateTime(DateTime.now().year - 50),
    lastDate: DateTime(DateTime.now().year + 50),
    initialDateRange: DateTimeRange(
      end: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 13),
      start: DateTime.now(),
    ),
  );

  return dateTimeRange;
}
