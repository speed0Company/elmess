import 'dart:convert';

import 'package:almes/models/data_model.dart';
import 'package:intl/intl.dart';

class Helper {

  String formatArabicDate(DateTime dateTime) {

    var formatter = DateFormat.MMMM('ar');

    return formatter.format(dateTime);

  }


List<CostData> parseCostData(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<CostData>((json) => CostData.fromJson(json)).toList();
}



  int getDaysInMonth(int year, int month) {
  // Handle invalid month
  if (month < 1 || month > 12) {
    throw ArgumentError('Month must be between 1 and 12');
  }

  // Create a DateTime object for the first day of the next month
  DateTime firstDayOfNextMonth = DateTime(year, month + 1, 1);

  // Subtract one day to get the last day of the current month
  DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));

  // Return the day of the month of the last day
  return lastDayOfMonth.day;
}

}
