import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hlfchat/models/message.dart';
import 'package:hlfchat/models/user.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:hlfchat/providers/chat_provider.dart';
import 'package:hlfchat/themes/text_theme.dart';

import '../providers/user_provider.dart';

class ChatScreen extends StatelessWidget {
  final UserModel? user;
  ChatScreen({
    Key? key,
    this.user,
  }) : super(key: key);
  final TextEditingController? messageController = TextEditingController();

  tapHandle(BuildContext context) {
    if (messageController!.text.isNotEmpty) {
      Provider.of<ChatProvider>(context, listen: false).sendMessage(
        user!.userID!,
        messageController!.text,
      );
      messageController!.clear();
    }
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
                    backgroundImage: NetworkImage(user!.photoUrl!),
                    radius: 22,
                  ),
                  Spacer(flex: 1),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user!.name!,
                          style: HLFTextTheme.kNameTextStyle,
                        ),
                        SizedBox(height: 3),
                        Text(
                          true ? 'Active Now' : 'Offline Now',
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
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  List<Message> msgs = [];
                  msgs = chatProvider.getMessages(user!.userID!);
                  return Container(
                    color: Color.fromARGB(255, 224, 225, 231),
                    child: ListView.builder(
                      itemCount: msgs.length,
                      itemBuilder: (context, index) {
                        return MessageBubble(
                          text: msgs[index].text!,
                          isMe: msgs[index].senderID != user!.userID!,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 45,
              width: Get.width * 0.94,
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 217, 219, 228),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: messageController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a message...',
                  hintStyle: HLFTextTheme.kTypeTextStyle,
                  contentPadding: EdgeInsets.all(14),
                  suffixIcon: SizedBox(
                    width: 55,
                    height: 25,
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
                            tapHandle(context);
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
                onSubmitted: (val) {
                  tapHandle(context);
                },
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
            margin: EdgeInsets.fromLTRB(
              isMe! ? 70 : 14,
              10,
              isMe! ? 14 : 70,
              2,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isMe! ? ForwardButton(isMe: isMe, message: text) : SizedBox(),
                isMe!
                    ? SizedBox(
                        width: 12,
                      )
                    : SizedBox(),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    text!,
                    softWrap: true,
                    style: HLFTextTheme.kChatTextStyle,
                  ),
                  decoration: BoxDecoration(
                    color: isMe!
                        ? Color.fromARGB(255, 255, 101, 101)
                        : Color.fromARGB(255, 55, 55, 55),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft:
                          isMe! ? Radius.circular(10) : Radius.circular(0),
                      bottomRight:
                          isMe! ? Radius.circular(0) : Radius.circular(10),
                    ),
                  ),
                ),
                isMe!
                    ? SizedBox()
                    : SizedBox(
                        width: 12,
                      ),
                isMe! ? SizedBox() : ForwardButton(isMe: isMe, message: text),
              ],
            ),
          ),
        ),
        isMe! ? SizedBox() : Spacer(),
      ],
    );
  }
}

class ForwardButton extends StatelessWidget {
  final String? message;
  final bool? isMe;
  const ForwardButton({
    Key? key,
    this.isMe,
    this.message,
  }) : super(key: key);

  forwardMessage(BuildContext context, bool isMe, String uid, String message) {
    Provider.of<ChatProvider>(context, listen: false).forwardMessage(
      uid,
      message,
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => GestureDetector(
        onTap: (() {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (_) {
                return Container(
                  height: 200,
                  width: Get.width,
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Send to:'),
                      SizedBox(height: 10),
                      Container(
                        height: 160,
                        width: Get.width,
                        child: ListView.builder(
                            itemCount: userProvider.otherUsers.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => forwardMessage(
                                  context,
                                  isMe!,
                                  userProvider.otherUsers[index].userID!,
                                  message!,
                                ),
                                child: Container(
                                  height: 48,
                                  width: Get.width * 0.9,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 231, 236, 241),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            userProvider
                                                .otherUsers[index].photoUrl!),
                                        radius: 16,
                                      ),
                                      SizedBox(width: 10),
                                      Text(userProvider.otherUsers[index].name!)
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              });
        }),
        child: Container(
          height: 18,
          width: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Icon(
            Icons.arrow_forward,
            size: 14,
          ),
        ),
      ),
    );
  }
}
