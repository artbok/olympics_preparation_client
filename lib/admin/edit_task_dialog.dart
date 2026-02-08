import "package:flutter/material.dart";
import 'package:olympics_preparation_client/requests/delete_tasks.dart';
import 'package:olympics_preparation_client/requests/edit_tasks.dart';

  void changedDialog(
    BuildContext context,
    int id,
    String description,
    String subject,
    String difficulty,
    String hint,
    String answer,
    String topic,
    VoidCallback refreshPage
  ) {
    final colors = Theme.of(context).colorScheme;
    final TextEditingController descriptionController = TextEditingController(
      text: description,
    );
    final TextEditingController hintController = TextEditingController(
      text: hint,
    );
    final TextEditingController answerController = TextEditingController(
      text: answer,
    );

    String selectedSubject = subject;
    String selectedDifficulty = difficulty;
    String selectedTopic = topic;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: colors.surface,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          child: Container(
            width: 500,
            constraints: const BoxConstraints(maxHeight: 700),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Редактировать задачу',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 40),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Описание задачи',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),

                  TextFormField(
                    controller: hintController,
                    decoration: const InputDecoration(
                      labelText: 'Подсказка',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),

                  TextFormField(
                    controller: answerController,
                    decoration: const InputDecoration(
                      labelText: 'Ответ',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  Container(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    ElevatedButton(
                    onPressed: () {
                      editTask(id, descriptionController.text, selectedSubject, selectedDifficulty, hintController.text, answerController.text, selectedTopic);
                      Navigator.pop(context);
                      refreshPage();
                    },
                    child: const Text(
                      'Сохранить',
                      style: TextStyle(color: Colors.white),
                    ),),
                    ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Отмена',
                      style: TextStyle(color: Colors.white),
                    ),)
                    ]
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void deleteDialog(BuildContext contex, int id, VoidCallback refreshPage) {
    deleteTask(id);
    refreshPage();
  }

