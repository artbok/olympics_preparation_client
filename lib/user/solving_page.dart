import "package:flutter/material.dart";
import 'package:olympics_preparation_client/widgets/change_task_activity.dart';

class SolvePage extends StatefulWidget {
  final int id;
  final String description;
  final String subject;
  final String difficulty;
  final String hint;
  final String answer;
  final String explanation;

  const SolvePage({
    super.key,
    required this.id,
    required this.description,
    required this.subject,
    required this.difficulty,
    required this.hint,
    required this.answer,
    required this.explanation,
  });

  @override
  State<SolvePage> createState() => _SolvePage();
}

class _SolvePage extends State<SolvePage> {
  final TextEditingController _answerController = TextEditingController();
  bool _showHint = false;
  bool _showExplanation = false;
  String buttonText = "Отправить";

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _checkAnswer() {
    String answer = _answerController.text.trim();
    if (answer.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Введите ответ!')));
      return;
    }
    if (widget.answer == answer) {
      buttonText = "Отправить";
      editTaskActivity(widget.id, "correct");
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ваш ответ: $answer - верный')));
    } else {
      buttonText = "Изменить ответ";
      editTaskActivity(widget.id, "incorrect");
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ваш ответ: $answer - неверный')));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Задание #${widget.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.subject,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.bolt,
                  color: widget.difficulty == 'Сложный'
                      ? Colors.red
                      : widget.difficulty == 'Средний'
                      ? Colors.orange
                      : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  'Сложность: ${widget.difficulty}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.difficulty == 'Сложный'
                        ? Colors.red
                        : widget.difficulty == 'Средний'
                        ? Colors.orange
                        : Colors.green,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Условие:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showHint ? Icons.lightbulb : Icons.lightbulb_outline,
                        color: Colors.amber.shade800,
                      ),
                      Text(
                        _showHint ? 'Скрыть подсказку' : 'Показать подсказку',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _showHint = !_showHint;
                    });
                  },
                ),
                Expanded(child: Container()),
              ],
            ),

            if (_showHint) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 65, 47, 102),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.hint,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            const Text(
              'Ваш ответ:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                hintText: 'Введите ответ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _checkAnswer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _showExplanation ? Icons.done_all : Icons.remove_done,
                        color: Colors.amber.shade800,
                      ),
                      Text(
                        _showExplanation
                            ? 'Скрыть решение'
                            : 'Показать решение',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _showExplanation = !_showExplanation;
                    });
                  },
                ),
                Expanded(child: Container()),
              ],
            ),
            if (_showExplanation) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.explanation,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
