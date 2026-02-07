import 'package:flutter/material.dart';


enum MatchOutcome { win, lose, draw }

class DuelResultPage extends StatefulWidget {
  final MatchOutcome outcome;
  final int rating;
  final int ratingDelta;

  const DuelResultPage({
    super.key,
    required this.outcome,
    required this.rating,
    required this.ratingDelta,
  });

  @override
  State<DuelResultPage> createState() => _DuelResultPageState();
}

class _DuelResultPageState extends State<DuelResultPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _ratingAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _ratingAnimation = IntTween(
      begin: widget.rating - widget.ratingDelta,
      end: widget.rating,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getOutcomeColor() {
    switch (widget.outcome) {
      case MatchOutcome.win:
        return Colors.green;
      case MatchOutcome.lose:
        return Colors.red;
      case MatchOutcome.draw:
        return Colors.orange;
    }
  }

  IconData getOutcomeIcon() {
    switch (widget.outcome) {
      case MatchOutcome.win:
        return Icons.emoji_events;
      case MatchOutcome.lose:
        return Icons.close;
      case MatchOutcome.draw:
        return Icons.handshake;
    }
  }

  String getOutcomeText() {
    switch (widget.outcome) {
      case MatchOutcome.win:
        return 'Победа';
      case MatchOutcome.lose:
        return 'Поражение';
      case MatchOutcome.draw:
        return 'Ничья';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;
    final deltaText =
        widget.ratingDelta >= 0 ? '+${widget.ratingDelta}' : '${widget.ratingDelta}';
    final deltaColor = widget.ratingDelta >= 0 ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат дуэли'),
        titleTextStyle: textThemes.titleMedium,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Icon(getOutcomeIcon(), size: 64, color: getOutcomeColor()),
                    const SizedBox(height: 12),
                    Text(
                      getOutcomeText(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: getOutcomeColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'Рейтинг',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _ratingAnimation,
                      builder: (context, child) {
                        return Text(
                          _ratingAnimation.value.toString(),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      deltaText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: deltaColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                          foregroundColor: Colors.white),
              child: const Text('Продолжить'),
            ),
          ],
        ),
      ),
    );
  }
}
