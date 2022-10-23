import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Widget defaultFlushbar({
  required BuildContext context,
  required String? message,
  Color color = Colors.green,
  Color messageColor = Colors.white,
  IconData? icon,
}) {
  return Flushbar(
    message: message,
    messageColor: messageColor,
    icon: Icon(icon),
    flushbarRoute: null,
    duration: Duration(seconds: 3),
    backgroundColor: color,
    margin: EdgeInsets.all(16),
    borderRadius: BorderRadius.circular(5.0),
  )..show(context);
}
