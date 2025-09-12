import "package:flutter/material.dart";

showSnackBar({
  required BuildContext context,
  required String message,
  int? duration,
  bool isError = true,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      duration: Duration(seconds: duration ?? 2),
      behavior: SnackBarBehavior.floating,
      backgroundColor: (isError) ? Colors.red : Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      action: SnackBarAction(
        label: "Ok",
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        textColor: Colors.white,
      ),
    ),
  );
}
