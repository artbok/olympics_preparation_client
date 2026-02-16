import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/widgets/button.dart';

void showIncorrectDataAlert(
  BuildContext context, [
  Widget title = const Text("Укажите правильные данные!"),
]) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final colors = Theme.of(context).colorScheme;
      final textThemes = Theme.of(context).textTheme;
      return AlertDialog(
        backgroundColor: colors.surface,
        title: title,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          button(Text("Ок", style: textThemes.bodyMedium), () {
            Navigator.pop(context);
          }),
        ],
      );
    },
  );
}
