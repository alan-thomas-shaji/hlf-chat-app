import 'package:flutter/material.dart';
import 'package:hlfchat/models/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

class ChatProvider with ChangeNotifier {
  List<Message> messages = [];
  final clientID = 'Navaneeth';
  final List<String> otherUsers = ['Jeffin', 'Jobin', 'Alan'];

  final IO.Socket socket = IO.io(
      'ws://msg-socket-server.herokuapp.com',
      IO.OptionBuilder()
          .setTransports(['websocket']).setQuery({'chatID': 'Jobin'}).build());

  socketInit() {
    print("Socket init");
    socket.onConnect((_) {
      print('connect');
      socket.emit('message', {
        'message': 'Connected to client device: $clientID',
      });
    });
    socket.onConnectError((data) {
      print('connect error ${data}');
    });
    socket.on('receive_message', (jsonData) {
      var data = jsonData as Map<String, dynamic>;
      // Map<dynamic, dynamic> data = json.decode(jsonData as String);
      print(data);
      Message message = Message(
        text: data['content'],
        senderID: data['senderChatID'],
        receiverID: data['receiverChatID'],
      );
      addMessage(message);
      notifyListeners();
    });

    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  sendMessage(String userName, String message) {
    socket.emit('message', {
      'receiverChatID': userName,
      'senderChatID': clientID,
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    });
    Message newMessage = Message(
      text: message,
      senderID: clientID,
      receiverID: userName,
    );
    // addMessage(newMessage);
  }

  void addMessage(Message message) {
    messages.add(message);
    notifyListeners();
  }

  // get message by receiver id and sender id
  List<Message> getMessages(String receiverId) {
    return messages
        .where((message) => (message.receiverID == receiverId &&
                message.senderID == clientID ||
            message.receiverID == clientID && message.senderID == receiverId))
        .toList();
  }
}
