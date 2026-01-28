import 'package:socket_io_client/socket_io_client.dart';
import 'package:olympics_preparation_client/localstorage.dart';

class SocketService {
  late Socket socket;

  void connectToServer(String username) {
    socket = io(
      "${getValue("serverAddress")}",
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    socket.connect();

    socket.onConnect((_) {
      print('Connected to backend');
      socket.emit('join', username);
    });
  }
  
  void sendMessage(String event, dynamic data) {
    socket.emit(event, data);
  }
}


