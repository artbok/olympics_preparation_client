import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'dart:ui';
import 'package:olympics_preparation_client/requests/get_elo_request.dart';
import 'package:olympics_preparation_client/widgets/button.dart';

class DuelPage extends StatefulWidget {
  const DuelPage({super.key});

  @override
  State<DuelPage> createState() => DuelPageState();
}

class DuelPageState extends State<DuelPage> {
  TextEditingController searchController = TextEditingController();
  String username = getValue("username");

  @override
  void initState() async {
    super.initState();
    int elo = await getElo(username);
    setState(() {
      rating = elo;
      isLoading = false;
    });
  }

  bool isLoading = true;
  int rating = 1000;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    //final textThemes = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: Container()),
              Row(
                children: [
                  Text("$username, "),
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    tween: Tween<double>(
                      begin: 3.0,
                      end: isLoading ? 3.0 : 0.0,
                    ),
                    builder: (context, blurValue, child) {
                      return ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: blurValue,
                          sigmaY: blurValue,
                        ),
                        child: child,
                      );
                    },
                    child: Text('${isLoading ? "1000" : rating} elo'),
                  ),
                ],
              ),
              Expanded(
                child: button(Text("Найти соперника"), () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: colors.surface,
                        title: Text("Поиск соперника..."),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          buttonDialog(
                            const Text(
                              "Отмена",
                              style: TextStyle(color: Colors.white),
                            ),
                            () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                      
                    },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
