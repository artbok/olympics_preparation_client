import "package:flutter/material.dart";
import 'package:olympics_preparation_client/user/pages/authorisation_page.dart';
import 'package:olympics_preparation_client/widgets/page_changer.dart';
import 'package:olympics_preparation_client/widgets/difficulty_indicator.dart';
import 'package:olympics_preparation_client/user/pages/solve_page.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class UserTasksPage extends StatefulWidget{
  const UserTasksPage({super.key});

  @override
  State<UserTasksPage> createState() => _UserTasksPage();
}

class _UserTasksPage extends State<UserTasksPage>{
  int currentPage = 1;
  int totalPages = 0;
  final List<String> selectedDifficulty = [];
  final List<String> selectedSubject = [];
  final List<String> selectedTopic = [];
  Widget getItemWidget(
    String id, String description, String subject, String difficulty, String Topic, BuildContext context){
        final colors = Theme.of(context).colorScheme;
        return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: InkWell(
                onTap: () => {
                  Navigator.pushReplacement(
                  context, 
                  PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero))},
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.secondary,
                    border: Border.all(
                      color: colors.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                      title: Row(children: [
                        Expanded(child: Text("$id     $description", overflow: TextOverflow.ellipsis, softWrap: true,),)
                        
                      ]),
                      subtitle: Row(children: [
                        difficultyIndicator(difficulty, subject),
                        Expanded(
                            child: Container())
                      ])
                      ))));
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

  void filterdialog(BuildContext context){
    final colors = Theme.of(context).colorScheme;
    final List<String> subjectlist = ['Математика', 'Астрономия', 'Информатика', 'Програмирование', 'bebra', 'brbrbrbrbbrbrbbrbrbrbrbrbbrbrbrbrbrbbrbrbrb'];
    final Map<String, String> topicmap = {'Математика':'1', 'Информатика':'2', 'Програмирование':'3'};
    final List<String> filtersDifficulty = List.from(selectedDifficulty);
    final List<String> filtersSubject = List.from(selectedSubject);
    final List<String> filtersTopic = List.from(selectedTopic);
    // final List<String> allFilters = filtersDifficulty + filtersSubject + filtersTopic;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Dialog(
          backgroundColor: colors.surface,
          insetPadding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child:  Container(
            width: 400, 
            constraints: const BoxConstraints(maxHeight: 500), 
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  const Text('Фильтры',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                StatefulBuilder(builder: (context, setState) { 
                bool isSelected(String label, List<String> category) {
                  return category.contains(label);
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
                  }
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15.0),
                  const Text('Сложность:', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                  Wrap(
                    children: <Widget>[
                      buildChip('Простой', filtersDifficulty),
                      buildChip('Средний', filtersDifficulty),
                      buildChip('Сложный', filtersDifficulty),
                    ],
                  ),
                ]
              );
            }),
              DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Select Subject',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: subjectlist.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    enabled: false,
                    child: StatefulBuilder(
                      builder: (context, menuSetState) {
                        final isSelected = filtersSubject.contains(item);
                        return InkWell(
                           onTap: () {
                            isSelected ? filtersSubject.remove(item) : filtersSubject.add(item);
                            menuSetState(() {});
                          },
                          child: Container(
                            height: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                if (isSelected)
                                  const Icon(Icons.check_box_outlined)
                                else
                                  const Icon(Icons.check_box_outline_blank),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  value: filtersSubject.isEmpty ? null : filtersSubject.last,
                  onChanged: (value) {},
                  selectedItemBuilder: (context) {
                    return subjectlist.map(
                      (item) {
                        return Container(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            filtersSubject.join(', '),
                            style: const TextStyle(
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        );
                      },
                    ).toList();
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(left: 16, right: 8),
                    height: 40,
                    width: 140,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
              DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Select Topic',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: topicmap.entries.map((entry) {
                  final String key = entry.key;
                  final String value = entry.value;
                  return DropdownMenuItem(
                    value: key,
                    enabled: false,
                    child: StatefulBuilder(
                      builder: (context, menuSetState) {
                        final isSelected = filtersTopic.contains(key);
                        return InkWell(
                           onTap: () {
                            if (isSelected) {
                              filtersTopic.remove(key);
                            } else {
                              filtersTopic.add(key);
                            }
                              menuSetState(() {});
                          },
                          child: Container(
                            height: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                if (isSelected)
                                  const Icon(Icons.check_box_outlined)
                                else
                                  const Icon(Icons.check_box_outline_blank),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),),
                          );
                        },
                      ),
                    );
                  }).toList(),
                  value: filtersTopic.isEmpty ? null : filtersTopic.last,
                  onChanged: (value) {},
                  selectedItemBuilder: (context) {
                    return topicmap.entries.map(
                      (entry) {
                        final String key = entry.key;
                                  final String value = entry.value;
                                  final List<String> selectedTopicNames = filtersTopic
                                      .map((key) => topicmap[key] ?? '')
                                      .where((name) => name.isNotEmpty)
                                      .toList();
                                  
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      selectedTopicNames.isEmpty
                                          ? 'Выберите тему'
                                          : selectedTopicNames.join(', '),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  );
                                },
                              ).toList();
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(left: 16, right: 8),
                    height: 40,
                    width: 140,
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  TextButton(
                          onPressed: (){
                            setState(() {
                              selectedDifficulty.clear();
                              selectedDifficulty.addAll(filtersDifficulty);
                              selectedSubject.clear();
                              selectedSubject.addAll(filtersSubject);
                              selectedTopic.clear();
                              selectedTopic.addAll(filtersTopic);
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                ],
              ),
            )
          )
        );
        
      }
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
      body:
        FutureBuilder(
            future: () async {
              List <Map<String, String>>h = [{"id":"2", 
              "description":"bebradcdcydtcyryttytytytyeyeyycrbebrafguybregbrebgkycrbgribguggibbuggubgbugbuggybuuybygubuufyfbugugnunoi", 
              "subject":"bebrast", 
              "difficulty":"Сложный", "topic":"uy"}, {"id":"3", 
              "description":"cf gjj fegueehi ulhhfbhjffffffffnhewwwd,;leeeecfiuon; ffffegu gutgyrtdgjuyrhtgrwrtyuio;lkjhgfds.,mnbvcxpoiuytubgyr", 
              "subject":"brbbrb", 
              "difficulty":"Средний", "topic":"bebra"},{"id":"1", 
              "description":"fwe", 
              "subject":"bebrast", 
              "difficulty":"Простой", "topic":"brrbrbrbb"}];
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
                for (int i = 0; i < data.length; i++){
                items.add(getItemWidget(
                    data[i]["id"],
                    data[i]["description"]!,
                    data[i]["subject"]!,
                    data[i]["difficulty"], 
                    data[i]["topic"], context));
            }
                if (items.isEmpty) {
                  return const Center(
                      child: Text(
                    "Ничего не найдено :(",
                    style: TextStyle(fontSize: 40),
                  ));
                }
                return Column(
                  children: [
                    Expanded(
                        flex: 6,
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: items,
                                ))))),
                    pageChanger(currentPage, totalPages, nextPage, previousPage)
                  ],
                );
              }
            }));
  }
}