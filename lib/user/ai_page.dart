import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:olympics_preparation_client/user/solving_page.dart'; 


void showAiPromptDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AiGenerationDialog(),
  );
}

class AiGenerationDialog extends StatefulWidget {
  const AiGenerationDialog({super.key});

  @override
  State<AiGenerationDialog> createState() => _AiGenerationDialogState();
}

class _AiGenerationDialogState extends State<AiGenerationDialog> {
  final TextEditingController _ctrl = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final prompt = _ctrl.text.trim();
    if (prompt.isEmpty) return;

    setState(() => loading = true);

    try {
      var res = await http.post(
        Uri.parse('http://127.0.0.1:5000/generate-task'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        if (data['success'] == true && data['task'] != null) {
          var taskData = data['task'];

          if (mounted) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SolvePage(
                  id: taskData['id'],
                  description: taskData['description'],
                  subject: taskData['subject'],
                  difficulty: taskData['difficulty'],
                  hint: taskData['hint'],
                  answer: taskData['answer'],
                  explanation: taskData['explanation'],
                ),
              ),
            );
          }
        }
      } else {
        throw Exception('Ошибка сервера: ${res.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;

    return AlertDialog(
      title: const Text('Генерация задачи'),
      titleTextStyle: textThemes.bodyLarge?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: loading
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Нейросеть придумывает задачу..."),
                ],
              )
            : TextField(
                controller: _ctrl,
                maxLines: 3,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText:
                      'Введите тему или условие (например: "Задача на логику про яблоки")',
                  border: OutlineInputBorder(),
                ),
              ),
      ),
      actions: loading
          ? [] 
          : [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: _generate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Генерировать'),
              ),
            ],
    );
  }
}
