import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService extends StatefulWidget {
  const SocketService({Key? key}) : super(key: key);

  @override
  State<SocketService> createState() => _SocketServiceState();
}

class _SocketServiceState extends State<SocketService> {
  late Socket socket;
  // initialize the Socket.IO Client Object
  @override
  void initState() {
    super.initState();
    initializeSocket(); //--> call the initializeSocket method in the initState of our app.
  }

  @override
  void dispose() {
    socket
        .destroy(); // --> disconnects the Socket.IO client once the screen is disposed
    super.dispose();
  }

  void initializeSocket() {
    socket = io("http://127.0.0.1:3000/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect(); //connect the Socket.IO Client to the Server

    //SOCKET EVENTS
    // --> listening for connection
    socket.on('connect', (data) {
      print(socket.connected);
    });

    //listen for incoming messages from the Server.
    socket.on('message', (data) {
      print(data); //
    });

    //listens when the client is disconnected from the Server
    socket.on('disconnect', (data) {
      print('disconnect');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
