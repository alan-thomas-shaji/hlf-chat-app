import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class OtherProvider with ChangeNotifier {
  Future<void> getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();
    print(statuses[Permission.location]);
  }
}
