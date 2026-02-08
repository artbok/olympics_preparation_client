import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/widgets/button.dart';

List<String> difficulties = ['легкий', 'средний', 'сложный'];
List<String> subjects = ['немецкий язык', 'математика', 'я устал'];

void createTaskDialog(BuildContext context, VoidCallback refreshPage) {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  TextEditingController hintController = TextEditingController();
  String? selectedDifficulty;
  String? selectedSubject;
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
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text("Новая задача", style: textTheme.titleLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Название",
                          labelStyle: textTheme.labelMedium,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: selectedDifficulty,
                              decoration: InputDecoration(
                                labelText: "Сложность",
                                labelStyle: textTheme.labelMedium,
                                border: OutlineInputBorder(),
                              ),
                              items: difficulties.map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDifficulty = newValue;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: selectedSubject,
                              decoration: InputDecoration(
                                labelText: "Предмет",
                                labelStyle: textTheme.labelMedium,
                                border: OutlineInputBorder(),
                              ),
                              items: subjects.map<DropdownMenuItem<String>>((
                                String value,
                              ) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedSubject = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: "Описание",
                          labelStyle: textTheme.labelMedium,
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: TextFormField(
                        controller: answerController,
                        decoration: InputDecoration(
                          labelText: "Ответ",
                          labelStyle: textTheme.labelMedium,
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: TextFormField(
                        controller: hintController,
                        decoration: InputDecoration(
                          labelText: "Подсказка",
                          labelStyle: textTheme.labelMedium,
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: button(
                              Text("Отмена", style: textTheme.bodySmall),
                              () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: button(
                              Text("Создать", style: textTheme.bodySmall),
                              () {
                                Navigator.pop(context);
                                refreshPage();
                              },
                            ),
                          ),
                        ],
                      ),
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
