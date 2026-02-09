import 'package:flutter/material.dart';
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
    String username = "1234";
    userData = getProfile(username);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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

          final userData = snapshot.data!;

          final rating = userData["rating"];
          final name = userData["name"] ?? userData["username"];
          final solvedCorrectly = userData["solvedCorrectly"];
          final solvedIncorrectly = userData["solvedIncorrectly"];
          final totalSolved = solvedCorrectly + solvedIncorrectly;

          List<int> ratingChanges = [10, 20, -10, 4, 10, -28];
          ratingChanges.add(rating);
          int temp = rating;
          for (int i = ratingChanges.length - 2; i >= 0; i--) {
            temp = temp - ratingChanges[i];
            ratingChanges[i] = temp;
          }

          final chartData = ratingChanges.asMap().entries.map((entry) {
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
                    Defaults.horizontalAxis..grid = null,
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
