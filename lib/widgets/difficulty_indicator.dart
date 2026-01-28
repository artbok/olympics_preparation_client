import 'package:flutter/material.dart';

Widget difficultyIndicator(String difficulty, String subject, [VoidCallback? onPressed]) {
  Map<String, LinearGradient> gradients = {
    "Простой": const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.fromARGB(255, 9, 235, 58),
          Color.fromARGB(255, 17, 161, 61),
        ],
        tileMode: TileMode.clamp),
    "Средний": const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.fromARGB(255, 255, 218, 8),
          Color.fromARGB(255, 252, 175, 60),
        ],
        tileMode: TileMode.clamp),
    "Сложный": const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.fromARGB(255, 235, 9, 9),
          Color.fromARGB(255, 255, 60, 11),
        ],
        tileMode: TileMode.clamp),
  };
  Widget container = Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
        gradient: gradients[difficulty], borderRadius: BorderRadius.circular(20)),
    child: Text(subject, style: const TextStyle(color: Colors.white)),
  );
  if (onPressed != null) {
    return InkWell(onTap: onPressed, child: container);
  }
  return container;
}