import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

//Firebase connection
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'get_started/get_started.dart';

//Mainpage
import 'wan_protector/wan_protector.dart';

void main() async {

  //Ensure Flutter binding is initialized before any async calls
  //WidgetsFlutterBinding.ensureInitialized();

  //Initialize FFI for desktop or test env
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  //Initialize Firebase
  //await Firebase.initializeApp(
  //  options: DefaultFirebaseOptions.currentPlatform,
  //);

  //Run the application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WanProtector Password Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 102, 255)),
        useMaterial3: true,
      ),
      home: WanProtector(),
    );
  }
}