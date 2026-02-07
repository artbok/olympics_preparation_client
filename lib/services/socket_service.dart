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
  final ValueNotifier<Map<String, dynamic>?> matchmakingNotifier =
      ValueNotifier<Map<String, dynamic>?>(null);
  final ValueNotifier<Map<String, dynamic>?> duelNotifier =
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
      matchmakingNotifier.value = data;
    });
  }

  void connectToDuel(String duelName) {
    socket.on(duelName, (data) {
      duelNotifier.value = data;
    });
  }

  void sendMessage(String event, dynamic data) {
    socket.emit(event, data);
  }
}
