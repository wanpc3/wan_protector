import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wan_protector/auth/login_user.dart';
import 'package:wan_protector/database/wp_database_helper.dart';
import 'package:wan_protector/get_started/get_started.dart';
import 'package:wan_protector/wan_protector/wan_protector.dart';

Future<bool> checkLoginStatus(BuildContext context) async {
  bool loggedIn = await WPDatabaseHelper.instance.isLoggedIn();

  // If the user is not logged in, navigate to the LoginUser page
  if (!loggedIn) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginUser())
    );
    return false;
  }
  return true;
}

Future<bool?> getInitialScreen() async {
  final storage = FlutterSecureStorage();
  String? isFirstTime = await storage.read(key: 'isFirstTime');
  bool loggedIn = await WPDatabaseHelper.instance.isLoggedIn();

  print("isFirstTime: $isFirstTime");
  print("loggedIn: $loggedIn");

  if (isFirstTime == null) {
    // If it's the first time the app is launched, go to GetStarted and mark it as not first time
    await storage.write(key: 'isFirstTime', value: 'false');
    return null; // First-time user, navigate to GetStarted
  } else if (!loggedIn) {
    // If the user is not logged in, go to LoginUser
    return false; // Not logged in, navigate to LoginUser
  } else {
    // If the user is logged in, navigate to WanProtector
    return true; // Logged in, navigate to WanProtector
  }
}
