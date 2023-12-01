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

Future<bool> getTempStatus() async {
  final preference = await SharedPreferences.getInstance();
  return preference.getBool('unit') ?? false;
}

showSnackBarMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}