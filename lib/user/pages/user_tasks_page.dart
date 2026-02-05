import "package:flutter/material.dart";
import 'package:olympics_preparation_client/user/pages/authorisation_page.dart';
import 'package:olympics_preparation_client/widgets/page_changer.dart';
import 'package:olympics_preparation_client/widgets/difficulty_indicator.dart';
import 'package:olympics_preparation_client/user/pages/solve_page.dart';

class UserTasksPage extends StatefulWidget{
  const UserTasksPage({super.key});

  @override
  State<UserTasksPage> createState() => _UserTasksPage();
}

class _UserTasksPage extends State<UserTasksPage>{
  int currentPage = 1;
  int totalPages = 0;
  Widget getItemWidget(
    String id, String description, String subject, String difficulty, String? hint, String answer, BuildContext context){
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
  final List<String> filters = [];
    Widget buildChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: filters.contains(label),
      onSelected: (bool value) {
          if (value) {
            filters.add(label);
          } else {
            filters.removeWhere((String name) => name == label);
          }

      },
    );
  }
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
        title: const Text('Фильтры'),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [const SizedBox(height: 3.0),
           Wrap(
              children: <Widget>[
                buildChip('Простой'),
                buildChip('Средний'),
                buildChip('Сложный'),
              ],
            ),]
        ),
        actions: <Widget>[
          TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
        ],
      ),
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
              "hint": "faaa", 
              "difficulty":"Сложный",
              "answer":"1234"
              }, {"id":"3", 
              "description":"cf gjj fegueehi ulhhfbhjffffffffnhewwwd,;leeeecfiuon; ffffegu gutgyrtdgjuyrhtgrwrtyuio;lkjhgfds.,mnbvcxpoiuytubgyr", 
              "subject":"brbbrb",
              "hint": "pepe", 
              "difficulty":"Средний",
              "answer":"1234"
              },{"id":"1", 
              "description":"fwe", 
              "subject":"bebrast", 
              "difficulty":"Простой",
              "answer":"1234"}];
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
                    data[i]["hint"],
                    data[i]["answer"],
                    context));
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