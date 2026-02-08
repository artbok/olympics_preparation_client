import "package:flutter/material.dart";
import 'package:olympics_preparation_client/admin/create_task_dialog.dart';
import 'package:olympics_preparation_client/widgets/admin_navigation.dart';
import 'package:olympics_preparation_client/widgets/page_changer.dart';
import 'package:olympics_preparation_client/widgets/difficulty_indicator.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'package:olympics_preparation_client/user/filter_dialog.dart';
import 'package:olympics_preparation_client/requests/get_tasks.dart';


class AdminTasksPage extends StatefulWidget {
  const AdminTasksPage({super.key});

  @override
  State<AdminTasksPage> createState() => _AdminTasksPage();
}

class _AdminTasksPage extends State<AdminTasksPage> {
  int currentPage = 1;
  int totalPages = 0;
  List<String> selectedDifficulties = ['Простой', 'Средний', 'Сложный'];
  late Map<String, dynamic> topics;
  final Set<String> selectedTopics = {};

  Widget getItemWidget(
    int id,
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
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "№$id          $description",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    difficultyIndicator(difficulty, "$subject, $topic"),
                    Expanded(child: Container()),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => changedDialog(
                context,
                id.toString(),
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
              onPressed: () => deleteDialog(context, id.toString()),
            ),
          ],
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

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Dialog(
    //       backgroundColor: colors.surface,
    //       insetPadding: const EdgeInsets.symmetric(
    //         horizontal: 20,
    //         vertical: 30,
    //       ),
    //       child: Container(
    //         width: 500,
    //         constraints: const BoxConstraints(maxHeight: 700),
    //         padding: const EdgeInsets.all(20),
    //         child: SingleChildScrollView(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               const Text(
    //                 'Редактировать задачу',
    //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    //               ),

    //               TextFormField(
    //                 controller: descriptionController,
    //                 decoration: const InputDecoration(
    //                   labelText: 'Описание задачи',
    //                   border: OutlineInputBorder(),
    //                 ),
    //                 maxLines: 3,
    //               ),

    //               TextFormField(
    //                 controller: hintController,
    //                 decoration: const InputDecoration(
    //                   labelText: 'Подсказка',
    //                   border: OutlineInputBorder(),
    //                 ),
    //                 maxLines: 3,
    //               ),

    //               TextFormField(
    //                 controller: answerController,
    //                 decoration: const InputDecoration(
    //                   labelText: 'Ответ',
    //                   border: OutlineInputBorder(),
    //                 ),
    //                 maxLines: 3,
    //               ),

    //               ElevatedButton(
    //                 onPressed: () {
    //                   final taskIndex = tasks.indexWhere(
    //                     (task) => task['id'] == id,
    //                   );

    //                   if (taskIndex != -1) {
    //                     setState(() {
    //                       tasks[taskIndex] = {
    //                         'id': selectedId,
    //                         'description': descriptionController.text,
    //                         'subject': selectedSubject,
    //                         'difficulty': selectedDifficulty,
    //                         'hint': hintController.text,
    //                         'answer': answerController.text,
    //                         'topic': selectedTopic,
    //                       };
    //                     });
    //                   }
    //                   Navigator.pop(context);
    //                 },
    //                 child: const Text(
    //                   'Сохранить',
    //                   style: TextStyle(color: Colors.white),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  void deleteDialog(BuildContext contex, String id) {
    // final taskIndex = tasks.indexWhere((task) => task['id'] == id);
    // if (taskIndex != -1) {
    //   setState(() {
    //     tasks.removeAt(taskIndex);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final username = getValue("username");
    final password = getValue("password");
    return scaffoldWithAdminNavigation(
      0,
      context,
      AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () => filterDialog(
              context,
              selectedDifficulties,
              selectedTopics,
              topics,
              () => setState(() {}),
            ),
          ),
        ],
      ),
      FutureBuilder(
        future: getTasks(
          username,
          password,
          selectedDifficulties,
          selectedTopics.toList(),
          currentPage,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Ошибка: ${snapshot.error}");
          } else {
            totalPages = snapshot.data!["totalPages"];
            List<Map<String, dynamic>> tasks = List<Map<String, dynamic>>.from(
              snapshot.data!["tasks"],
            );
            topics = snapshot.data!["topics"];
            List<Widget> items = [];
            for (int i = 0; i < tasks.length; i++) {
              items.add(
                getItemWidget(
                  tasks[i]["id"]!,
                  tasks[i]["description"]!,
                  tasks[i]["subject"]!,
                  tasks[i]["difficulty"]!,
                  tasks[i]["hint"],
                  tasks[i]["answer"],
                  tasks[i]["topic"],
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
      FloatingActionButton(
        onPressed: () {
          createTaskDialog(context, () => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
