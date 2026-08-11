import 'package:client/core/themes/primitives/colors.dart';
import 'package:flutter/material.dart';

class NotificationUtils {
  NotificationUtils();

  static void error(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: ZintraColorPrimitives.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: ZintraColorPrimitives.destructive500,
        ),
      );

  static void info(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: ZintraColorPrimitives.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: ZintraColorPrimitives.mintGreen500,
        ),
      );
}
