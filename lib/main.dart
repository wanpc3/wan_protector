import 'package:flutter/material.dart';
import 'get_started/get_started_1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 102, 255)),
        useMaterial3: true,
      ),
      home: GetStarted1(),
    );
  }
}