import 'package:flutter/material.dart';

class DuelPage extends StatefulWidget {
  final String username;
  final int userRating;
  final String opponent;
  final int opponentRating;

  const DuelPage({super.key, required this.username, required this.userRating, 
    required this.opponent, required this.opponentRating});

  @override
  State<DuelPage> createState() => DuelPageState();
}

class DuelPageState extends State<DuelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Ожидание начала дуэли..."),
          Row(children: [
            Text("${widget.username}, ${widget.userRating} elo"),
            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 20), child: Text("VS")),
            Text("${widget.opponent}, ${widget.opponentRating} elo"),
            ]),
        ],
      ),
    );
  }
}
