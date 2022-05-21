import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'providers/chat_provider.dart';
import 'providers/other_provider.dart';
import 'providers/user_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OtherProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MyMaterial(),
    ),
  );
}

class MyMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Consumer2<OtherProvider, UserProvider>(
        builder: (context, otherProvider, userProvider, child) {
          otherProvider.getPermission();
          return Home();
        },
      ),
    );
  }
}
