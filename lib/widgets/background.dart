import 'package:flutter/material.dart';

Widget background(Widget child) {
  return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color.fromARGB(255, 250, 250, 210),
            Color.fromARGB(255, 255, 250, 205),
            Color.fromARGB(255, 208, 221, 237),
            Color.fromARGB(255, 255, 218, 185)
          ])),
      child: child);
}

Widget background1(Widget child) {
  return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color.fromARGB(0, 228, 255, 255),
            Color.fromARGB(180, 0, 255, 255),
            Color.fromARGB(0, 255, 127, 255),
            Color.fromARGB(255, 0, 127, 255)
          ])),
      child: child);
}

Widget backgroundDialog(Widget child) {
  return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 255, 248, 220),
                Color.fromARGB(255, 255, 228, 196),
                Color.fromARGB(255, 222, 184, 135),
                Color.fromARGB(255, 250, 128, 114)
              ])),
      child: child);
}