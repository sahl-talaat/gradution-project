import 'package:flutter/material.dart';

Widget defaultFieldText({
  String? hint,
  String? includedtext,
  String? initValue,
  String? contentfieldOnsave,
  String? dataEnter,
  Text? label,
  IconButton? sufix,
  Icon? preffix,
  bool isPassword = false,
  Function(String?)? validate,
  Function(String?)? onSave,
  TextInputType? keyboardType,
  TextEditingController? mycontroller,
}) {
  return Container(
    padding: EdgeInsets.all(5.0),
    child: TextFormField(
      initialValue: initValue,
      obscureText: isPassword,
      keyboardType: keyboardType,
      controller: mycontroller,
      validator: (text) {
        return validate!(text);
      },
      onSaved: (text) {
        return onSave!(text);
      },
      decoration: InputDecoration(
        suffixIcon: sufix,
        prefixIcon: preffix,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        label: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
    ),
  );
}
