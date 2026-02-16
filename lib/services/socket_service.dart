import 'package:socket_io_client/socket_io_client.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'package:flutter/material.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  Socket? socket;

  final ValueNotifier<Map<String, dynamic>?> matchmakingNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);
  final ValueNotifier<Map<String, dynamic>?> duelNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);
  final ValueNotifier<Map<String, dynamic>?> scoreNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);

  void connectToServer(String username) {
    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
    }

    socket = io(
      "${getValue("serverAddress")}",
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      socket!.emit('matchmaking', username);
    });

    socket!.on("matchmaking_$username", (data) {
      matchmakingNotifier.value = data;
    });
  }

  void connectToDuel(String duelName) {
    if (socket == null) return;

    socket!.off(duelName);

    socket!.on(duelName, (data) {
      if (data["code"] == "answerResponse") {
        scoreNotifier.value = data;
      }
      duelNotifier.value = data;
    });
  }

  void sendMessage(String event, dynamic data) {
    if (socket != null && socket!.connected) {
      socket!.emit(event, data);
    }
  }
}
