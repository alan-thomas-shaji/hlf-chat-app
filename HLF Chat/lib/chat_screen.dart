import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hlfchat/themes/text_theme.dart';

import 'models/user_model.dart';

class ChatScreen extends StatefulWidget {
  final User? user;
  ChatScreen({Key? key, this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Container(
                height: Get.height * 0.75,
                color: Color.fromARGB(255, 234, 235, 241),
                child: ListView.builder(
                  itemCount: widget.user!.messages!.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                      text: widget.user!.messages![index].content!,
                      isMe: widget.user!.messages![index].isMe,
                    );
                  },
                )),
            Container(
              height: 45,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 217, 219, 228),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a message...',
                  hintStyle: HLFTextTheme.kStatusTextStyle,
                  contentPadding: EdgeInsets.all(9),
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
    return Container(
      padding: EdgeInsets.all(6),
      child: Text(text!),
      decoration: BoxDecoration(
          color: isMe! ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(7),
            topRight: Radius.circular(7),
            bottomLeft: isMe! ? Radius.circular(7) : Radius.circular(0),
            bottomRight: isMe! ? Radius.circular(0) : Radius.circular(7),
          )),
    );
  }
}
