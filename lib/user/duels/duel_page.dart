import 'package:flutter/material.dart';
import 'package:olympics_preparation_client/services/socket_service.dart';
import 'package:timer_widget/timer_widget.dart';

class DuelPage extends StatefulWidget {
  final String duelName;
  final String username;
  final int userRating;
  final String opponent;
  final int opponentRating;

  const DuelPage({
    super.key,
    required this.duelName,
    required this.username,
    required this.userRating,
    required this.opponent,
    required this.opponentRating,
  });

  @override
  State<DuelPage> createState() => DuelPageState();
}

class DuelPageState extends State<DuelPage> {
  List<String> tasks = [];
  int userScore = 0;
  int opponentScore = 0;
  TextEditingController controller = TextEditingController();

  Future<void> wait() async {
    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    final socketService = SocketService();
    socketService.sendMessage(widget.duelName, {
      "operation": "join",
      "username": widget.username,
    });
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: socketService.duelNotifier,
        builder: (context, data, child) {
          if (data == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Ожидание начала дуэли..."),
                Row(
                  children: [
                    Text("${widget.username}, ${widget.userRating} elo"),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                      child: Text("VS"),
                    ),
                    Text("${widget.opponent}, ${widget.opponentRating} elo"),
                  ],
                ),
              ],
            );
          } else if (data["code"] == "start_duel") {
            tasks = [data["task"]];
            wait();
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListTile(
                      title: Text(widget.username),
                      subtitle: Text("$userScore points"),
                    ),
                    TimerWidget(
  id: "timer", 
  timerType: TimerType.countdown,
  timeOutInSeconds: 300,
  builder: (context, state) {
    return Text(state.isCounting ? "\${state.remainingSeconds}s" : "Start");
  },
),
                    ListTile(
                      title: Text(widget.opponent),
                      subtitle: Text("$opponentScore points"),
                    ),
                  ],
                ),
                Center(child: Text(tasks[0])),
                TextField(controller: controller),
                ElevatedButton(
                  onPressed: () {
                    socketService.sendMessage("duelname", {
                      "operation": "answer",
                      "answer": controller.text,
                    });
                  },
                  child: Text("Ответить"),
                ),
              ],
            );
          }
          return Text("bebra");
        },
      ),
    );
  }
}
