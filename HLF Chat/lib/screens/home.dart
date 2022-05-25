import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hlfchat/models/user.dart';
import 'package:hlfchat/providers/user_provider.dart';
import 'package:hlfchat/screens/chat_screen.dart';
import 'package:hlfchat/providers/chat_provider.dart';

import 'package:hlfchat/themes/text_theme.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> bottomNav = [true, false, false, false];

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false).socketInit();
    Provider.of<ChatProvider>(context, listen: false).getData();
    Provider.of<UserProvider>(context, listen: false).getData();
    Provider.of<UserProvider>(context, listen: false).getOtherUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style: HLFTextTheme.kSubHeadTextStyle,
        ),
        actions: [
          Consumer<UserProvider>(
            builder: (context, userProvider, child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () => userProvider.signOutFromGoogle(),
                child: CircleAvatar(
                  radius: 18,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(userProvider.user.photoURL!),
                  ),
                ),
              ),
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) => userProvider.isLoading
            ? Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: Color.fromARGB(255, 255, 96, 96),
                    strokeWidth: 3,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: Get.width,
                  child: userProvider.otherUsers.isEmpty
                      ? Center(child: Text('Nothing Here Yet'))
                      : ListView.builder(
                          itemCount: userProvider.otherUsers.length,
                          itemBuilder: (context, index) {
                            return ChatListHeader(
                              user: userProvider.otherUsers[index],
                            );
                          },
                        ),
                ),
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
  final UserModel? user;
  const ChatListHeader({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ChatScreen(user: user),
          transition: Transition.rightToLeft,
        );
      },
      child: Padding(
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
                  radius: 25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(user!.photoUrl!),
                  ),
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
                        'You: Okay',
                        style: HLFTextTheme.kStatusTextStyle,
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '04:25 PM',
                      style: HLFTextTheme.kTimeTextStyle,
                    ),
                    Container(
                      height: 7,
                      width: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
