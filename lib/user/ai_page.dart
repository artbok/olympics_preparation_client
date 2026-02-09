import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<String> tasks = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Задачи')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPromptDialog(),
        child: const Icon(Icons.add),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(child: Text('Пока что нет задач'))
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, i) => ListTile(
                    title: Text(tasks[i]),
                    leading: const Icon(Icons.circle_outlined),
                  ),
                ),
    );
  }

  void _showPromptDialog() {
    final textThemes = Theme.of(context).textTheme;
    final ctrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Введите запрос для генерации'),
        titleTextStyle: textThemes.bodyMedium,
        content: SizedBox(
          width: double.infinity,
          child: TextField(
            controller: ctrl,
            maxLines: 3,
            autofocus: true
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final text = ctrl.text.trim();
              if (text.isEmpty) return;
              Navigator.pop(context);
              _generate(text);
                  },
            child: const Text('ОК'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _generate(String prompt) async {
    setState(() => loading = true);

    try {
      var res = await http.post(
        Uri.parse('http://127.0.0.1:5000/generate-task'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        setState(() => tasks = List<String>.from(data['tasks']));
      } else {
        throw Exception('Ошибка ${res.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не получилось: $e')),
        );
      }
    } finally {
      setState(() => loading = false);
    }
  }
}