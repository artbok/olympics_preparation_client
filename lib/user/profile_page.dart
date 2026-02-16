import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'package:olympics_preparation_client/requests/get_profile.dart';
import 'package:graphic/graphic.dart';
import 'package:olympics_preparation_client/widgets/user_navigation.dart';
import 'package:olympics_preparation_client/requests/get_user_solved_topic.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> userData;
  late Future<Map<String, dynamic>> userSolvedData;

  @override
  void initState() {
    super.initState();
    userData = getProfile(getValue("username"));
    userSolvedData = getUserTopics(getValue("username"), getValue("password"));
  }

  Widget buildTableCell(String text, TextTheme textThemes, {bool isData = false}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: isData ? textThemes.bodyLarge : textThemes.titleMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return scaffoldWithUserNavigation(
      2,
      context,
      AppBar(),
      FutureBuilder<Map<String, dynamic>>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_off, size: 50),
                  const SizedBox(height: 16),
                  Text('Профиль не найден', style: textThemes.headlineSmall),
                ],
              ),
            );
          }

          final userData = snapshot.data!;

          final rating = userData["rating"] ?? -1;
          final name = userData["username"] ?? "Неизвестный";
          final solvedCorrectly = userData["solvedCorrectly"] ?? -1;
          final solvedIncorrectly = userData["solvedIncorrectly"] ?? -1;
          final totalSolved = solvedCorrectly + solvedIncorrectly;
          final averageAnswerTime = userData["averageAnswerTime"];
          List<int> ratingHistory = [];
          final rawRatingChanges = userData["ratingChanges"];
          
          if (rawRatingChanges is List && rawRatingChanges.isNotEmpty) {
            ratingHistory = List<int>.from(
              rawRatingChanges.map((e) => int.tryParse(e.toString()) ?? 0),
            );

            ratingHistory.add(rating);
            int current = rating;
            for (int i = ratingHistory.length - 2; i >= 0; i--) {
              current = current - ratingHistory[i];
              ratingHistory[i] = current;
            }
          } else {
            ratingHistory = [rating];
          }

          final chartData = ratingHistory.asMap().entries.map((entry) {
            return {'index': entry.key, 'value': entry.value};
          }).toList();

          return FutureBuilder<Map<String, dynamic>>(
            future: userSolvedData,
            builder: (context, solvedSnapshot) {
              if (solvedSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (solvedSnapshot.hasError) {
                return Center(
                  child: Text('Ошибка загрузки тем: ${solvedSnapshot.error}'),
                );
              }

              final solvedData = solvedSnapshot.data ?? {};

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        name,
                        style: textThemes.headlineLarge,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Table(
                        border: TableBorder.all(),
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: colors.surface,
                            ),
                            children: [
                              buildTableCell("Рейтинг", textThemes),
                              buildTableCell("Правильно", textThemes),
                              buildTableCell("Всего", textThemes),
                              buildTableCell("Ср. время ответа", textThemes),
                            ],
                          ),
                          TableRow(
                            children: [
                              buildTableCell("$rating", textThemes, isData: true),
                              buildTableCell("$solvedCorrectly", textThemes, isData: true),
                              buildTableCell("$totalSolved", textThemes, isData: true),
                              buildTableCell(
                                averageAnswerTime != null 
                                    ? "${averageAnswerTime.toStringAsFixed(1)} с" 
                                    : "0 с",
                                textThemes,
                                isData: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 200,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Chart(
                        data: chartData,
                        variables: {
                          'index': Variable<Map<String, dynamic>, int>(
                            accessor: (Map<String, dynamic> datum) =>
                                datum['index'] as int,
                          ),
                          'value': Variable<Map<String, dynamic>, int>(
                            accessor: (Map<String, dynamic> datum) =>
                                datum['value'] as int,
                          ),
                        },
                        marks: [
                          LineMark(
                            color: ColorEncode(value: Colors.blue),
                            size: SizeEncode(value: 2.0),
                          ),
                        ],
                        axes: [
                          Defaults.horizontalAxis
                            ..grid = null
                            ..label = LabelStyle(
                              textStyle: const TextStyle(color: Colors.transparent),
                            ),
                          Defaults.verticalAxis,
                        ],
                        coord: RectCoord(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Прогресс по темам",
                      style: textThemes.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    if (solvedData.isEmpty)
                      const Center(
                        child: Text("Нет данных по темам"),
                      )
                    else
                      ...buildSubjectTables(solvedData, textThemes, buildTableCell, colors),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

List<Widget> buildSubjectTables(
  Map<String, dynamic> data, 
  TextTheme textThemes,
  Widget Function(String, TextTheme, {bool isData}) buildTableCell,
  ColorScheme colors
) {
  List<Widget> tables = [];
  
  data.forEach((subject, topics) {
    if (topics is Map && topics.isNotEmpty) {
      tables.add(
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  subject,
                  style: textThemes.titleLarge,
                ),
              ),
              Table(
                border: TableBorder.all(),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: colors.surface,
                    ),
                    children: [
                      buildTableCell("Тема", textThemes),
                      buildTableCell("Решено верно", textThemes),
                      buildTableCell("Всего", textThemes),
                    ],
                  ),
                  ...buildTopicRows(topics, textThemes),
                ],
              ),
            ],
          ),
        ),
      );
    }
  });
  
  return tables;
}

List<TableRow> buildTopicRows(Map<dynamic, dynamic> topics, TextTheme textThemes) {
  List<TableRow> rows = [];
  
  topics.forEach((topic, stats) {
    int solved = stats['solved'] ?? -1;
    int total = stats['total'] ?? -1 ;
    
    rows.add(
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              topic,
              style: textThemes.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$solved',
              style: textThemes.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$total',
              style: textThemes.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  });
  
  return rows;
}