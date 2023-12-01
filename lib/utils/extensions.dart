import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getFormattedDateTime(num dt, {String pattern = 'dd/MM/yyyy'}) {
  return DateFormat(pattern).format(DateTime.fromMillisecondsSinceEpoch(dt.toInt() * 1000));
}

Future<bool> setTempStatus(bool status) async {
  final preference = await SharedPreferences.getInstance();
  return preference.setBool('unit', status);
}

Future<bool> setTempIntStatus(int status) async {
  try {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt('unit', status);
    return true; // Indicates that the operation was successful
  } catch (e) {
    print('Error setting int value in SharedPreferences: $e');
    return false; // Indicates that an error occurred
  }
}

Future<bool> getTempStatus() async {
  final preference = await SharedPreferences.getInstance();
  return preference.getBool('unit') ?? false;
}

Future<int?> getTempIntStatus() async {
  try {
    final preferences = await SharedPreferences.getInstance();
    // If the key 'unit' is not found, getInt will return null
    return preferences.getInt('unit');
  } catch (e) {
    print('Error getting int value from SharedPreferences: $e');
    return 0; // Indicates that an error occurred
  }
}

showSnackBarMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}