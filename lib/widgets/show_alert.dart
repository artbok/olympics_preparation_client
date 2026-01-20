import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/button.dart';

void showIncorrectDataAlert(BuildContext context, [Widget title = const Text("Укажите правильные данные!")]) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 222, 173),
          title: title,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            buttonDialog(
                  const Text("Ок",
                  style: TextStyle(color: Colors.white),
                  ),
                 () {
                  Navigator.pop(context);
                },)
          ],
        );
      });
}