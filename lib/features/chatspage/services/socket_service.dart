import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  io.Socket? socket;

  void connectAndListen(String chatId) {
    socket = io.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
    socket!.emit('joinChat', chatId);

    socket!.on('message', (data) {
      print("New message: $data");
      // Handle incoming message
    });
  }

  void sendMessage(String chatId, String senderId, String text) {
    socket?.emit(
        'sendMessage', {'chatId': chatId, 'senderId': senderId, 'text': text});
  }

  void disconnect() {
    socket?.disconnect();
  }
}
