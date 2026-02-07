import 'dart:async';
import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/widgets/button.dart';


class FindingMatchDialog extends StatefulWidget {
  const FindingMatchDialog({super.key});

  @override
  State<FindingMatchDialog> createState() => _FindingMatchDialogState();
}

class _FindingMatchDialogState extends State<FindingMatchDialog> {
  int _dots = 0;
  bool _isAlive = true;

  @override
  void initState() {
    super.initState();
    _animate();
  }

  void _animate() async {
    while (_isAlive) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          _dots = (_dots + 1) % 4;
        });
      }
    }
  }

  @override
  void dispose() {
    _isAlive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: colors.surface,
      title: Text("Поиск соперника${"." * _dots}"),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        button(
          const Text("Отмена", style: TextStyle(color: Colors.white)),
          () => Navigator.pop(context),
        ),
      ],
    );
  }
}
