import 'package:socket_io_client/socket_io_client.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late Socket socket;
  final ValueNotifier<Map<String, dynamic>?> notifier =
      ValueNotifier<Map<String, dynamic>?>(null);
  void connectToServer(String username) {
    socket = io(
      "${getValue("serverAddress")}",
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );
    socket.connect();

    socket.onConnect((_) {
      print('Connected to backend');
      socket.emit('matchmaking', username);
    });
    socket.on("matchmaking_$username", (data) {
      print("что то пришло");
      switch (data["code"]) {
        case "match_found":
          {
            notifier.value = {
              "page": "game_page",
              "opponent": data["opponent"]["name"],
              "rating": data["opponent"]["rating"],
            };
          }
      }
    });
  }

  void connectToDuel(String duelName) {
    socket.on(duelName, (data) {
      // startRound
      // answer
      // 
    });
  }

  void sendMessage(String event, dynamic data) {
    socket.emit(event, data);
  }
}
