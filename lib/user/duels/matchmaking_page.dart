import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'dart:ui';
import 'package:olympics_preparation_client/requests/get_rating.dart';
import 'package:olympics_preparation_client/widgets/button.dart';
import 'package:olympics_preparation_client/user/duels/finding_match_dialog.dart';
import 'package:olympics_preparation_client/services/socket_service.dart';
import 'package:olympics_preparation_client/user/duels/duel_page.dart';

class MatchmakingPage extends StatefulWidget {
  const MatchmakingPage({super.key});

  @override
  State<MatchmakingPage> createState() => MatchmakingPageState();
}

class MatchmakingPageState extends State<MatchmakingPage> {
  String username = getValue("username");
  bool isLoading = true;
  int rating = 1000;

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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
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
            ),
            Expanded(
              child: Center(
                child: button(
                  const Text(
                    "Найти соперника",
                    style: TextStyle(color: Colors.white),
                  ),
                  () {
                    final socketService = SocketService();
                    socketService.connectToServer(username);
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return ValueListenableBuilder(
                          valueListenable: socketService.matchmakingNotifier,
                          builder: (context, val, child) {
                            if (val != null && val["code"] == "match_found") {
                              Widget page = DuelPage(
                                duelName: val["duelName"],
                                username: username,
                                userRating: rating,
                                opponent: val["opponent"]["name"],
                                opponentRating: val["opponent"]["rating"],
                              );
                              socketService.matchmakingNotifier.value = null;
                              return page;
                            }
                            return FindingMatchDialog();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
