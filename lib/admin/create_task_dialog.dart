import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/requests/create_tasks.dart';
import 'package:olympics_preparation_client/widgets/show_alert.dart';

List<String> difficulties = ['Простой', 'Средний', 'Сложный'];

void createTaskDialog(BuildContext context, VoidCallback refreshPage) {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  TextEditingController explanationController = TextEditingController();
  TextEditingController hintController = TextEditingController();

  String selectedDifficulty = 'Простой';

  final textTheme = Theme.of(context).textTheme;
  final colors = Theme.of(context).colorScheme;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: colors.surface,
        insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Новая задача", style: textTheme.titleLarge),
                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
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
                        }
                      },
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
                      decoration: InputDecoration(
                        labelText: "Описание",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: answerController,
                      decoration: InputDecoration(
                        labelText: "Ответ",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: hintController,
                      decoration: InputDecoration(
                        labelText: "Подсказка",
                        labelStyle: textTheme.labelMedium,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: explanationController,
                      decoration: InputDecoration(
                        labelText: "Объяснение",
                        labelStyle: textTheme.labelMedium,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

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
                            if (descriptionController.text.isNotEmpty &&
                                subjectController.text.isNotEmpty &&
                                hintController.text.isNotEmpty &&
                                answerController.text.isNotEmpty &&
                                explanationController.text.isNotEmpty &&
                                topicController.text.isNotEmpty) {
                              createTask(
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
                            } else {
                              showIncorrectDataAlert(context);
                            }
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
            );
          },
        ),
      );
    },
  );
}
