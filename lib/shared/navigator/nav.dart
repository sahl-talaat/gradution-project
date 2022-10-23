import 'package:flutter/material.dart';

void navigatTo(context, Widget) => Navigator.of(context)
    .push(MaterialPageRoute(builder: ((context) => Widget)));

void navigateAndFinish(context, Widget) =>
    Navigator.of(context).pushAndRemoveUntil(
        (MaterialPageRoute(builder: ((context) => Widget))), (route) => false);
