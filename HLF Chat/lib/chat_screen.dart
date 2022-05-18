import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:hlfchat/themes/text_theme.dart';

import 'models/user_model.dart';

class ChatScreen extends StatefulWidget {
  final User1? user;
  final IO.Socket? socket;
  ChatScreen({Key? key, this.user, this.socket}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  taphandle() {
    widget.socket!.emit('message', {
      'reciever': widget.user!.name,
      'sender': 'Jobin',
      'message': 'Hello',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 234, 235, 241),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar.jpg'),
                    radius: 22,
                  ),
                  Spacer(flex: 1),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.user!.name!,
                          style: HLFTextTheme.kNameTextStyle,
                        ),
                        SizedBox(height: 3),
                        Text(
                          widget.user!.isOnline! ? 'Active Now' : 'Offline Now',
                          style: HLFTextTheme.kStatusTextStyle,
                        ),
                      ],
                    ),
                  ),
                  Spacer(flex: 18),
                  IconButton(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.centerRight,
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Color.fromARGB(255, 224, 225, 231),
                child: ListView.builder(
                  itemCount: widget.user!.messages!.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      text: widget.user!.messages![index].content!,
                      isMe: widget.user!.messages![index].isMe,
                    );
                  },
                ),
              ),
            ),
            Container(
              height: 45,
              padding: EdgeInsets.all(11),
              margin: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 217, 219, 228),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a message...',
                  hintStyle: HLFTextTheme.kTypeTextStyle,
                  contentPadding: EdgeInsets.all(14),
                  suffixIcon: SizedBox(
                    width: 50,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Image.asset(
                            'assets/icons/attachment.png',
                            width: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            taphandle();
                          },
                          child: Image.asset(
                            'assets/icons/send.png',
                            width: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String? text;
  final bool? isMe;
  const MessageBubble({
    Key? key,
    this.text,
    this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isMe! ? Spacer() : SizedBox(),
        Flexible(
          flex: 6,
          child: Container(
            margin:
                EdgeInsets.fromLTRB(isMe! ? 70 : 14, 10, isMe! ? 14 : 70, 1),
            padding: EdgeInsets.all(8),
            child: Text(text!, softWrap: true),
            decoration: BoxDecoration(
              color: isMe! ? Colors.cyan : Color.fromARGB(255, 180, 180, 180),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: isMe! ? Radius.circular(10) : Radius.circular(0),
                bottomRight: isMe! ? Radius.circular(0) : Radius.circular(10),
              ),
            ),
          ),
        ),
        isMe! ? SizedBox() : Spacer(),
      ],
    );
  }
}
