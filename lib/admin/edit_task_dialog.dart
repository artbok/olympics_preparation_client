import "package:flutter/material.dart";
import 'package:olympics_preparation_client/requests/delete_tasks.dart';
import 'package:olympics_preparation_client/requests/edit_tasks.dart';

List<String> difficulties = ['Простой', 'Средний', 'Сложный'];

void changedDialog(
  BuildContext context,
  int id,
  String description,
  String subject,
  String difficulty,
  String hint,
  String answer,
  String explanation,
  String topic,
  VoidCallback refreshPage) {
  final colors = Theme.of(context).colorScheme;
  final TextEditingController descriptionController = TextEditingController(
    text: description,
  );
  final TextEditingController subjectController = TextEditingController(
    text: subject,
  );
  final TextEditingController topicController = TextEditingController(
    text: topic,
  );
  final TextEditingController hintController = TextEditingController(
    text: hint,
  );
  final TextEditingController answerController = TextEditingController(
    text: answer,
  );
  final TextEditingController explanationController = TextEditingController(
    text: explanation,
  );

  String selectedDifficulty = difficulty;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: colors.surface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                
                StatefulBuilder(
                  builder: (context, setState) {               
                    return DropdownButtonFormField<String>(
                        value: selectedDifficulty,
                        decoration: const InputDecoration(
                          labelText: "Сложность",
                          border: OutlineInputBorder(),
                        ),
                        items: difficulties.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() => selectedDifficulty = newValue);
                          }},
                        );
                      }
                    ),
                    const SizedBox(height: 20),
                    

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: subjectController,
                              decoration: InputDecoration(
                                labelText: "Предмет",
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: topicController,
                              decoration: InputDecoration(
                                labelText: "Тема",
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание задачи',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),


                TextFormField(
                  controller: hintController,
                  decoration: const InputDecoration(
                    labelText: 'Подсказка',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: answerController,
                  decoration: const InputDecoration(
                    labelText: 'Ответ',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),              

                TextFormField(
                  controller: explanationController,
                  decoration: const InputDecoration(
                    labelText: 'Объяснение',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),

                Container(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Отмена',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        editTask(
                          id,
                          descriptionController.text,
                          subjectController.text,
                          selectedDifficulty,
                          hintController.text,
                          answerController.text,
                          explanationController.text,
                          topicController.text,
                        );
                        Navigator.pop(context);
                        refreshPage();
                      },
                      child: const Text(
                        'Сохранить',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
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
