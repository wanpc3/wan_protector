import 'package:flutter/material.dart';
import 'get_started_2.dart';

class GetStarted1 extends StatelessWidget{
  GetStarted1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: 
        
            ElevatedButton(
                onPressed: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GetStarted2()));
                },
                child: Text('Go to Next Page')),
      ),
    );
  }
}