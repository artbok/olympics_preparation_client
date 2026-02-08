import "package:flutter/material.dart";
import 'package:olympics_preparation_client/widgets/page_changer.dart';
import 'package:olympics_preparation_client/widgets/difficulty_indicator.dart';
import 'package:olympics_preparation_client/user/pages/solve_page.dart';

class AdminTasksPage extends StatefulWidget {
  const AdminTasksPage({super.key});

  @override
  State<AdminTasksPage> createState() => _AdminTasksPage();
}

class _AdminTasksPage extends State<AdminTasksPage> {
  int currentPage = 1;
  int totalPages = 0;
  final List<String> selectedDifficulty = ['Простой', 'Средний', 'Сложный'];
  final Map<String, List<String>> _data = {
    'Математика': ['1', '4'],
    'Информатика': ['2'],
    'Програмирование': ['3', '7'],
  };
  final Set<String> selectedItem = {};

  List<Map<String, String>> tasks = [];

  Map<String, dynamic> currentTask = {};

  Widget getItemWidget(
    String id,
    String description,
    String subject,
    String difficulty,
    String? hint,
    String answer,
    String topic,
    BuildContext context,
  ) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: InkWell(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SolvePage(
                id: id,
                description: description,
                subject: subject,
                difficulty: difficulty,
                hint: hint ?? "Подсказки нет",
                answer: answer,
              ),
            ),
          ),
        },
        child: Container(
          decoration: BoxDecoration(
            color: colors.secondary,
            border: Border.all(color: colors.primary, width: 2.0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text(
                    "$id     $description",
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  subtitle: Row(
                    children: [
                      difficultyIndicator(difficulty, subject),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => changedDialog(
                  context,
                  id,
                  description,
                  subject,
                  difficulty,
                  hint ?? '',
                  answer,
                  topic,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteDialog(context, id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void nextPage() {
    setState(() {
      currentPage++;
    });
  }

  void previousPage() {
    setState(() {
      currentPage--;
    });
  }

  void changedDialog(
    BuildContext context,
    String id,
    String description,
    String subject,
    String difficulty,
    String hint,
    String answer,
    String topic,
  ) {
    currentTask = {
      'id': id,
      'description': description,
      'subject': subject,
      'difficulty': difficulty,
      'hint': hint,
      'answer': answer,
      'topic': topic,
    };

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

    String selectedId = id;
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

                  ElevatedButton(
                    onPressed: () {
                      final taskIndex = tasks.indexWhere(
                        (task) => task['id'] == id,
                      );

                      if (taskIndex != -1) {
                        setState(() {
                          tasks[taskIndex] = {
                            'id': selectedId,
                            'description': descriptionController.text,
                            'subject': selectedSubject,
                            'difficulty': selectedDifficulty,
                            'hint': hintController.text,
                            'answer': answerController.text,
                            'topic': selectedTopic,
                          };
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Сохранить',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void deleteDialog(BuildContext contex, String id) {
    final taskIndex = tasks.indexWhere((task) => task['id'] == id);
    if (taskIndex != -1) {
      setState(() {
        tasks.removeAt(taskIndex);
      });
    }
  }

  void filterDialog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final List<String> filtersDifficulty = List.from(selectedDifficulty);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: colors.surface,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 30,
          ),
          child: Container(
            width: 400,
            constraints: const BoxConstraints(maxHeight: 500),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Фильтры',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      bool isSelected(String label, List<String> category) {
                        return category.contains(label);
                      }

                      void toggleCategory(String category, bool? isSelected) {
                        setState(() {
                          if (isSelected == true) {
                            selectedItem.addAll(_data[category]!);
                          } else {
                            selectedItem.removeAll(_data[category]!);
                          }
                        });
                      }

                      void toggleItem(String item) {
                        setState(() {
                          if (selectedItem.contains(item)) {
                            selectedItem.remove(item);
                          } else {
                            selectedItem.add(item);
                          }
                        });
                      }

                      Widget buildChip(String label, List<String> category) {
                        return FilterChip(
                          label: Text(label),
                          selected: isSelected(label, category),
                          onSelected: (bool value) {
                            setState(() {
                              if (value) {
                                category.add(label);
                              } else {
                                category.remove(label);
                              }
                            });
                          },
                        );
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 15.0),
                          const Text(
                            'Сложность:',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Wrap(
                            children: <Widget>[
                              buildChip('Простой', filtersDifficulty),
                              buildChip('Средний', filtersDifficulty),
                              buildChip('Сложный', filtersDifficulty),
                            ],
                          ),

                          ExpansionTile(
                            title: const Text("Предметы"),
                            children: _data.entries.map((category) {
                              final String catName = category.key;
                              final List<String> items = category.value;

                              final int selectedCount = items
                                  .where((i) => selectedItem.contains(i))
                                  .length;
                              final bool allSelected =
                                  selectedCount == items.length;
                              final bool noneSelected = selectedCount == 0;

                              return ExpansionTile(
                                leading: Checkbox(
                                  value: allSelected
                                      ? true
                                      : (noneSelected ? false : null),
                                  tristate: true,
                                  onChanged: (bool? value) =>
                                      toggleCategory(catName, value),
                                ),
                                title: Text(catName),
                                children: items.map((item) {
                                  return CheckboxListTile(
                                    contentPadding: const EdgeInsets.only(
                                      left: 40,
                                    ),
                                    title: Text(item),
                                    value: selectedItem.contains(item),
                                    onChanged: (bool? value) =>
                                        toggleItem(item),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  );
                                }).toList(),
                              );
                            }).toList(),
                          ),

                          TextButton(
                            onPressed: () {
                              setState(() {
                                selectedDifficulty.clear();
                                selectedDifficulty.addAll(filtersDifficulty);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    tasks = [
      {
        "id": "2",
        "description":
            "bebradcdcydtcyryttytytytyeyeyycrbebrafguybregbrebgkycrbgribguggibbuggubgbugbuggybuuybygubuufyfbugugnunoi",
        "subject": "bebrast",
        "topic": "gegweg",
        "hint": "faaa",
        "difficulty": "Сложный",
        "answer": "1234",
      },
      {
        "id": "3",
        "description":
            "cf gjj fegueehi ulhhfbhjffffffffnhewwwd,;leeeecfiuon; ffffegu gutgyrtdgjuyrhtgrwrtyuio;lkjhgfds.,mnbvcxpoiuytubgyr",
        "subject": "brbbrb",
        "topic": "gegweg",
        "hint": "pepe",
        "difficulty": "Средний",
        "answer": "1234",
      },
      {
        "id": "1",
        "description": "fwe",
        "subject": "bebrast",
        "topic": "gegweg",
        "hint": "pepe",
        "difficulty": "Простой",
        "answer": "1234",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> data = [];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => filterDialog(context),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 300), () => tasks),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Ошибка: ${snapshot.error}");
          } else {
            totalPages = 10;
            data = snapshot.data!;
            List<Widget> items = [];
            for (int i = 0; i < data.length; i++) {
              items.add(
                getItemWidget(
                  data[i]["id"]!,
                  data[i]["description"]!,
                  data[i]["subject"]!,
                  data[i]["difficulty"]!,
                  data[i]["hint"],
                  data[i]["answer"],
                  data[i]["topic"],
                  context,
                ),
              );
            }
            if (items.isEmpty) {
              return const Center(
                child: Text(
                  "Ничего не найдено :(",
                  style: TextStyle(fontSize: 40),
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SingleChildScrollView(
                        child: Column(children: items),
                      ),
                    ),
                  ),
                ),
                pageChanger(currentPage, totalPages, nextPage, previousPage),
              ],
            );
          }
        },
      ),
    );
  }
}
