import 'package:socket_io_client/socket_io_client.dart';
import 'package:olympics_preparation_client/localstorage.dart';
import 'package:flutter/material.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  // Make socket nullable to handle "not connected" state
  Socket? socket;

  final ValueNotifier<Map<String, dynamic>?> matchmakingNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);
  final ValueNotifier<Map<String, dynamic>?> duelNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);
  final ValueNotifier<Map<String, dynamic>?> scoreNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);

  void connectToServer(String username) {
    // 1. Disconnect existing socket if it exists to prevent duplicates
    if (socket != null) {
      socket!.disconnect();
      socket!.dispose();
    }

    // 2. Create new connection
    socket = io(
      "${getValue("serverAddress")}",
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print('Connected to backend');
      socket!.emit('matchmaking', username);
    });

    // 3. Listen for matchmaking results
    socket!.on("matchmaking_$username", (data) {
      print("Matchmaking update: $data");
      matchmakingNotifier.value = data;
    });
  }

  void connectToDuel(String duelName) {
    if (socket == null) return;

    // Remove existing listeners for this event to avoid duplicates
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
      print("Sending $event: $data");
      socket!.emit(event, data);
    } else {
      print("Cannot send message: Socket disconnected");
    }
  }
}
