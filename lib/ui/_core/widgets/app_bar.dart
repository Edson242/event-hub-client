import 'package:flutter/material.dart';

AppBar getAppBar({required BuildContext context, String? title}) {
  return AppBar(
    title: title != null ? Text(title) : null,
    centerTitle: true,
  );
}
