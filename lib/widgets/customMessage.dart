import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CustomMsg {
  void customMsg (String myMsg){
    Fluttertoast.showToast(
      msg: myMsg,
      toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
  }
}