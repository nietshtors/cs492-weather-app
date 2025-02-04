import 'package:intl/intl.dart';

String convertTimestampToDayAndHour(DateTime dateTime) {

  DateTime today = DateTime.now();

  String dayOfWeek = equalDates(today, dateTime) ? 'Today' : DateFormat('EEEE').format(dateTime);

  String hour = DateFormat('h a').format(dateTime); // 12-hour format with AM/PM

  return '$dayOfWeek, $hour';
}

bool equalDates(DateTime day1, DateTime day2){
  if (DateTime(day1.year, day1.month, day1.day) == DateTime(day2.year, day2.month, day2.day)){
    return true;
  }
  else {
    return false;
  }
  
}