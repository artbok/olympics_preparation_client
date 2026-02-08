import 'package:flutter/material.dart';

enum MatchOutcome { win, lose, draw }

class DuelResultPage extends StatelessWidget {
  final MatchOutcome outcome;
  final int rating;
  final int delta;

  const DuelResultPage({
    super.key,
    required this.outcome,
    required this.rating,
    required this.delta,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String text;

    switch (outcome) {
      case MatchOutcome.win:
        color = Colors.green;
        icon = Icons.emoji_events;
        text = 'Победа';
        break;
      case MatchOutcome.lose:
        color = Colors.red;
        icon = Icons.close;
        text = 'Поражение';
        break;
      case MatchOutcome.draw:
        color = Colors.orange;
        icon = Icons.handshake;
        text = 'Ничья';
        break;
    }

    String deltaText = delta >= 0 ? '+$delta' : '$delta';
    Color deltaColor = delta >= 0 ? Colors.green : Colors.red;
    final textThemes = Theme.of(context).textTheme;


    return Scaffold(
      appBar: AppBar(title: const Text('Результат'),titleTextStyle: textThemes.titleMedium),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 80, color: color),
                    const SizedBox(height: 20),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Рейтинг',
                      style: TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '$rating',
                      style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      deltaText,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: deltaColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                    child: const Text('OK'),
                      ),
              ]),

            ),
    );
  }
}