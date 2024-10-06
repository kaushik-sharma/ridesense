import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UiHelpers {
  static void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.all(10.r),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      content: Text(message),
    ));
  }
}
