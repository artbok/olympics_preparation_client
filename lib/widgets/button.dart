import 'package:flutter/material.dart';

Widget button(Widget child, VoidCallback? func) {
  return ElevatedButton(
      onPressed: func,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(109, 224, 255, 1),
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.black,
          width: 1.5,
        ),
      )),
      child: child);
}

Widget buttonDialog(Widget child, VoidCallback? func) {
  return ElevatedButton(
      onPressed: func,
      
      style: ElevatedButton.styleFrom(
         backgroundColor: const Color.fromARGB(109, 224, 255, 1),
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(
          color: Colors.black,
          width: 1.5,
        ),
      )),
      child: child);
}