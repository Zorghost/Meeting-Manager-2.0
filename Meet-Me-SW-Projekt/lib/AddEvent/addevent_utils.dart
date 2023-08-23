import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
///this class is to change the date to string
class Utils {
// cange date to string
  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return '$time';
  }


}