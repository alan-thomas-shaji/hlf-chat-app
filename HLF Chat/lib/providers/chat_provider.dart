import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hlfchat/models/message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:unique_identifier/unique_identifier.dart';

class ChatProvider with ChangeNotifier {
  bool isLoading = false;
  bool isChatListEmpty = true;
  List<Message> messages = [];
  String apiUrl = 'https://msg-restapi.herokuapp.com';
  late String clientID;
  String imei = '';

  final IO.Socket socket = IO.io(
      'ws://msg-socket-server.herokuapp.com',
      IO.OptionBuilder()
          .setTransports(['websocket']).setQuery({'chatID': 'User'}).build());

  getData() async {
    final box = GetStorage();
    clientID = box.read('userID');
    messages = await getPastMessages(clientID);
    imei = (await UniqueIdentifier.serial)!;
  }

  socketInit() {
    print("Socket init");
    socket.onConnect((_) {
      print('Connected to socket');
    });
    socket.onConnectError((data) {
      print('connect error $data');
    });
    socket.on('receive_message', (jsonData) {
      var data = jsonData as Map<String, dynamic>;
      // Map<dynamic, dynamic> data = json.decode(jsonData as String);
      print(jsonData);
      Message message = Message.fromJson(data);
      addMessage(message);
      isLoading = false;
      notifyListeners();
    });

    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  sendMessage(String receiverId, String message) {
    socket.emit('message', {
      'receiverChatID': receiverId,
      'senderChatID': clientID,
      'message': message,
      'deviceMAC': imei,
      'timestamp': DateTime.now().toIso8601String(),
    });
    Message newMessage = Message(
      text: message,
      senderID: clientID,
      receiverID: receiverId,
      isMedia: false,
      timestamp: DateTime.now(),
    );
    // addMessage(newMessage);
  }

  sendMedia(String receiverId, String message, Uint8List bytes) {
    isLoading = true;
    notifyListeners();
    socket.emit('media', {
      'receiverChatID': receiverId,
      'senderChatID': clientID,
      'message': message,
      'deviceMAC': imei,
      'image': bytes,
      'timestamp': DateTime.now().toIso8601String(),
    });
    Message newMessage = Message(
      text: message,
      senderID: clientID,
      receiverID: receiverId,
      isMedia: true,
      timestamp: DateTime.now(),
    );
    // addMessage(newMessage);
  }

  forwardMessage(String receiverId, String message, String id) {
    socket.emit('forward', {
      'messageID': id,
      'receiverChatID': receiverId,
      'senderChatID': clientID,
      'message': message,
      'deviceMAC': imei,
      'timestamp': DateTime.now().toIso8601String(),
    });
    Message newMessage = Message(
      text: message,
      senderID: clientID,
      receiverID: receiverId,
      isMedia: false,
      timestamp: DateTime.now(),
    );
    // addMessage(newMessage);
  }

  void addMessage(Message message) {
    messages.add(message);
    notifyListeners();
  }

  getPastMessages(String userID) async {
    http.Response response =
        await http.get(Uri.parse(apiUrl + '/messages/all/$userID'));

    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      print(response.body);
      List<Message> messages = l.map((i) => Message.fromJson(i)).toList();
      return messages;
    } else {
      throw Error();
    }
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
