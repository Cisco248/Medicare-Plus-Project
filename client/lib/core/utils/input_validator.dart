import 'package:flutter/material.dart';

class InputValidator {
  InputValidator();

  static String init(TextEditingController fieldController, String param) {
    final value = fieldController.text;
    if (value == '') return "Field is Empty!, Enter the $param";
    return '';
  }
}
