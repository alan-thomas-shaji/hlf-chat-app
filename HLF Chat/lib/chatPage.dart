import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

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
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 60,
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
              icon: Icon(
                FontAwesomeIcons.message,
                color: bottomNav[0] ? Colors.black : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  bottomNav = [false, true, false, false];
                });
              },
              icon: Icon(
                FontAwesomeIcons.phone,
                color: bottomNav[1] ? Colors.black : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  bottomNav = [false, false, true, false];
                });
              },
              icon: Icon(
                FontAwesomeIcons.user,
                color: bottomNav[2] ? Colors.black : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  bottomNav = [false, false, false, true];
                });
              },
              icon: Icon(
                FontAwesomeIcons.gear,
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
            color: Color.fromARGB(255, 230, 230, 230),
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
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jaime Allen'),
                    SizedBox(height: 4),
                    Text('You: Okay'),
                  ],
                ),
              ),
              Spacer(flex: 16),
              Text('Time')
            ],
          ),
        ),
      ),
    );
  }
}
