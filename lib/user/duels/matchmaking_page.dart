import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:olympics_preparation_client/localstorage.dart';
import 'package:olympics_preparation_client/requests/get_rating.dart';
import 'package:olympics_preparation_client/widgets/button.dart';
import 'package:olympics_preparation_client/user/duels/finding_match_dialog.dart';
import 'package:olympics_preparation_client/services/socket_service.dart';
import 'package:olympics_preparation_client/user/duels/duel_page.dart';
import 'package:olympics_preparation_client/widgets/user_navigation.dart';

class MatchmakingPage extends StatefulWidget {
  const MatchmakingPage({super.key});

  @override
  State<MatchmakingPage> createState() => MatchmakingPageState();
}

class MatchmakingPageState extends State<MatchmakingPage> {
  String username = getValue("username");
  bool isLoading = true;
  int rating = 1000;
  final socketService = SocketService();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      int elo = await getRating(username);
      if (mounted) {
        setState(() {
          rating = elo;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _startMatchmaking() {
    socketService.matchmakingNotifier.value = null;

    socketService.connectToServer(username);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return ValueListenableBuilder(
          valueListenable: socketService.matchmakingNotifier,
          builder: (context, val, child) {
            if (val != null && val["code"] == "match_found") {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(dialogContext).pop();
                _navigateToDuel(val);
              });
            }
            return FindingMatchDialog();
          },
        );
      },
    );
  }

  void _navigateToDuel(Map<String, dynamic> data) {
    socketService.connectToDuel(data["duelName"]);

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => DuelPage(
              duelName: data["duelName"],
              username: username,
              userRating: rating,
              opponent: data["opponent"]["name"],
              opponentRating: data["opponent"]["rating"],
            ),
          ),
        )
        .then((_) {
          print("Returned from duel, refreshing rating...");
          socketService.matchmakingNotifier.value = null;
          fetchData(); 
        });
  }

  @override
  Widget build(BuildContext context) {
    return scaffoldWithUserNavigation(
      1,
      context,
      AppBar(),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("$username, "),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  tween: Tween<double>(begin: 3.0, end: isLoading ? 3.0 : 0.0),
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
          ),
          Expanded(
            child: Center(
              child: button(
                const Text(
                  "Найти соперника",
                  style: TextStyle(color: Colors.white),
                ),
                _startMatchmaking,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
