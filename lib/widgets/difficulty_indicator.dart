import 'package:flutter/material.dart';

Widget difficultyIndicator(String difficulty, String subject, [VoidCallback? onPressed]) {
  Map<String, LinearGradient> gradients = {
    "Простой": const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.fromARGB(255, 26, 133, 49),
          Color.fromARGB(255, 15, 71, 32),
        ],
        tileMode: TileMode.clamp),
    "Средний": const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.fromARGB(255, 206, 177, 12),
          Color.fromARGB(255, 122, 106, 14),
        ],
        tileMode: TileMode.clamp),
    "Сложный": const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color.fromARGB(255, 160, 18, 18),
          Color.fromARGB(255, 105, 23, 23),
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