import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
}

showToast(String msg, {bool? isError}) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.TOP, // valid options: TOP, CENTER, BOTTOM
    backgroundColor: isError == true ? Colors.red : AppColors.greenPrimary,
    webBgColor: isError == true
        ? colorToHex(AppColors.redPrimary)
        : colorToHex(AppColors.greenPrimary),
    timeInSecForIosWeb: 2,
    webShowClose: true,
    textColor: AppColors.white,
    toastLength: Toast.LENGTH_SHORT,
    fontSize: 16.0,
  );
}
