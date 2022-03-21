import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hlfchat/themes/text_theme.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

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
                          'Jaime Allen',
                          style: HLFTextTheme.kNameTextStyle,
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Active Now',
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
            ),
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
