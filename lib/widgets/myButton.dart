import 'package:flutter/material.dart';


Widget myButton(VoidCallback onTap, String title, bool loading) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(10)
      ),
      height: 50,
      width: 160,
      child: Center(
        child: loading 
        ? CircularProgressIndicator(color: Colors.white, strokeWidth: 4,) 
        : Text(title,style: TextStyle(fontSize: 25,color: Colors.white),)),
    ),
  );
}