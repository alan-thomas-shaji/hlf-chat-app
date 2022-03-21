import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hlfchat/themes/text_theme.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> bottomNav = [true, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style: HLFTextTheme.kSubHeadTextStyle,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.jpg'),
              radius: 18,
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ChatListHeader(),
            ChatListHeader(),
            ChatListHeader(),
            ChatListHeader(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 38, vertical: 5),
        height: 52,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  bottomNav = [true, false, false, false];
                });
              },
              icon: Image.asset(
                'assets/icons/chat.png',
                color: bottomNav[0] ? Colors.black : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  bottomNav = [false, true, false, false];
                });
              },
              icon: Image.asset(
                'assets/icons/phone.png',
                color: bottomNav[1] ? Colors.black : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  bottomNav = [false, false, true, false];
                });
              },
              icon: Image.asset(
                'assets/icons/user.png',
                color: bottomNav[2] ? Colors.black : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  bottomNav = [false, false, false, true];
                });
              },
              icon: Image.asset(
                'assets/icons/settings.png',
                color: bottomNav[3] ? Colors.black : Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChatListHeader extends StatelessWidget {
  const ChatListHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.all(14),
          height: 75,
          width: Get.width * 0.94,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 231, 236, 241),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
                radius: 25,
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
                      'You: Okay',
                      style: HLFTextTheme.kStatusTextStyle,
                    ),
                  ],
                ),
              ),
              Spacer(flex: 16),
              Text(
                '04:25 PM',
                style: HLFTextTheme.kTimeTextStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
