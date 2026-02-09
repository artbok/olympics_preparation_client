import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'package:olympics_preparation_client/requests/get_profile.dart';
import 'package:graphic/graphic.dart';
import 'package:olympics_preparation_client/widgets/user_navigation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    userData = getProfile(getValue("username"));
  }

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;

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

          final rating = userData["rating"] ?? 0;
          final name = userData["username"] ?? "Неизвестный";
          final solvedCorrectly = userData["solvedCorrectly"] ?? 0;
          final solvedIncorrectly = userData["solvedIncorrectly"] ?? 0;
          final totalSolved = solvedCorrectly + solvedIncorrectly;

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
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(name, style: textThemes.headlineLarge),
              const SizedBox(height: 15),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: [
                      Text("Рейтинг: $rating", style: textThemes.bodyMedium),
                      Text(
                        "Правильно решено: $solvedCorrectly",
                        style: textThemes.bodyMedium,
                      ),
                      Text(
                        "Всего решено: $totalSolved",
                        style: textThemes.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
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
                        textStyle: TextStyle(color: Colors.transparent),
                      ),
                    Defaults.verticalAxis,
                  ],
                  coord: RectCoord(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
