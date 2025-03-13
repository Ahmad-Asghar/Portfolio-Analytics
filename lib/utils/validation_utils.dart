import 'dart:io';
import 'app_exports.dart';
import 'package:flutter/material.dart';

bool validateEmail(String? email) {

  print('Email $email');

  if (email == null || email.isEmpty) {
    return false;
  }
  String pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$";
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(email)) {
    return false;
  }
  return true;
}

bool validatePassword(String? password, {int minLength = 6}) {
  if (password == null || password.isEmpty) {
    return false;
  }
  if (password.length < minLength) {
    return false;
  }
  return true;
}

bool validateField(String? value, {String fieldName = "Field"}) {
  if (value == null || value.isEmpty) {
    return false;
  }
  return true;
}

bool validateMatchingFields(String? value1, String? value2,
    {String fieldName = "Field"}) {
  if (value1 != value2) {
    return false;
  }
  return true;
}

bool validateNumber(String? value, {int? exactLength}) {
  if (value == null || value.isEmpty) {
    return false;
  }
  final numericRegex = RegExp(r'^[0-9]+$');
  if (!numericRegex.hasMatch(value)) {
    return false;
  }
  if (exactLength != null && value.length != exactLength) {
    return false;
  }
  return true;
}

bool validateURL(String? url) {
  if (url == null || url.isEmpty) {
    return false;
  }
  const urlPattern = r'(http|https):\/\/([\w-]+(\.[\w-]+)+)';
  if (!RegExp(urlPattern).hasMatch(url)) {
    return false;
  }
  return true;
}

bool validateAlphabets(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }
  if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
    return false;
  }
  return true;
}

void showSnackBar(BuildContext context, String message,{bool isError = false,bool onTop=false}) {
  final snackBar = SnackBar(
    backgroundColor: isError?Colors.red:Colors.green ,
    margin: EdgeInsets.only(left: 4.w,right:4.w,bottom:onTop? 77.h:2.h),
    behavior: SnackBarBehavior.floating,
      content: CustomTextWidget(title: message,color: Colors.white),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<bool> isConnectedToInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}

// String formatDateFromString(String dateString) {
//   DateTime date = DateTime.parse(dateString);
//   return DateFormat('dd MMM yyyy').format(date);
// }
