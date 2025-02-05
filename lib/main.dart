import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'auth/login_status.dart';

//Firebase connection
import 'package:firebase_core/firebase_core.dart';
import 'package:wan_protector/auth/register_user.dart';
import 'firebase_options.dart';

import 'get_started/get_started.dart';

//Mainpage
import 'wan_protector/wan_protector.dart';

//login page
import 'auth/login_user.dart';

//Adaptive theme
import 'package:adaptive_theme/adaptive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Load env variables
  //await dotenv.load();

  //Initialize FFI for desktop or test env
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    print("Running on desktop...");
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;  
  }

  // Initialize the database
  //await initDatabase(); 
  await Firebase.initializeApp();

  // Restore saved theme mode
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  //Run the application
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {

  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'WanProtector Password Manager',
        theme: theme,
        darkTheme: darkTheme,
        home: FutureBuilder<bool?>(
        future: getInitialScreen(),
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              if (snapshot.data == false) {
                return const LoginUser(); // Not logged in, go to LoginUser()
              } else if (snapshot.data == true) {
                return const WanProtector(); // Logged in, go to WanProtector()
              }
            }

            // If snapshot.data is null, navigate to GetStarted()
            return const GetStarted(); // First-time user, go to GetStarted()
          },
        ),
      ),
    );
  }
}