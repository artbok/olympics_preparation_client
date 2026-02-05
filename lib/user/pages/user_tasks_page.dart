import "package:flutter/material.dart";
import 'package:olympics_preparation_client/user/pages/authorisation_page.dart';
import 'package:olympics_preparation_client/widgets/page_changer.dart';
import 'package:olympics_preparation_client/widgets/difficulty_indicator.dart';
import 'package:olympics_preparation_client/user/pages/solve_page.dart';


class UserTasksPage extends StatefulWidget {
  const UserTasksPage({super.key});

  @override
  State<UserTasksPage> createState() => _UserTasksPage();
}

class _UserTasksPage extends State<UserTasksPage> {
  int currentPage = 1;
  int totalPages = 0;
  final List<String> selectedDifficulty = ['Простой', 'Средний', 'Сложный'];
  final Map<String, List<String>> _data = {
    'Математика': ['1', '4'],
    'Информатика': ['2'],
    'Програмирование': ['3', '7'],
  };
  final Set<String> selectedItem = {};

  Widget getItemWidget(
    String id,
    String description,
    String subject,
    String difficulty,
    String Topic,
    BuildContext context,
  ) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: InkWell(
        onTap: () => {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SolvePage(id: id, description: description, subject: subject, difficulty: difficulty, hint: hint ?? "Подсказки нет", answer: answer,)))
                
        },
        child: Container(
          decoration: BoxDecoration(
            color: colors.secondary,
            border: Border.all(color: colors.primary, width: 2.0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    "$id     $description",
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            subtitle: Row(
              children: [
                difficultyIndicator(difficulty, subject),
                Expanded(child: Container()),
              ],
            ),
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


  void filterdialog(BuildContext context) {
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
                      final bool allSelected = selectedCount == items.length;
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
                            contentPadding: const EdgeInsets.only(left: 40),
                            title: Text(item),
                            value: selectedItem.contains(item),
                            onChanged: (bool? value) => toggleItem(item),
                            controlAffinity: ListTileControlAffinity.leading,
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
                  )]);
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
  Widget build(BuildContext context) {
    List<dynamic> data = [];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => filterdialog(context),
          ),
        ],
      ),
      body: FutureBuilder(
        future: () async {
          List<Map<String, String>> h = [
            {
              "id": "2",
              "description":
                  "bebradcdcydtcyryttytytytyeyeyycrbebrafguybregbrebgkycrbgribguggibbuggubgbugbuggybuuybygubuufyfbugugnunoi",
              "subject": "bebrast",
              "difficulty": "Сложный",
              "topic": "uy",
            },
            {
              "id": "3",
              "description":
                  "cf gjj fegueehi ulhhfbhjffffffffnhewwwd,;leeeecfiuon; ffffegu gutgyrtdgjuyrhtgrwrtyuio;lkjhgfds.,mnbvcxpoiuytubgyr",
              "subject": "brbbrb",
              "difficulty": "Средний",
              "topic": "bebra",
            },
            {
              "id": "1",
              "description": "fwe",
              "subject": "bebrast",
              "difficulty": "Простой",
              "topic": "brrbrbrbb",
            },
          ];
          return h;
        }(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Ошибка: ${snapshot.error}");
          } else {
            totalPages = 10;
            data = snapshot.data!;
            List<Widget> items = [];
            print(data.toString());
            for (int i = 0; i < data.length; i++) {
              items.add(
                getItemWidget(
                  data[i]["id"],
                  data[i]["description"]!,
                  data[i]["subject"]!,
                  data[i]["difficulty"],
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
