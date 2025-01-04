import 'package:flutter/material.dart';

class Vault extends StatelessWidget {

  const Vault({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vault'),
      ),
      body: const Center(child: Text('Hello World')),
    ));
  }
}