import 'package:flutter/material.dart';
import '../strings/strings.dart';
import 'get_started_1.dart';

class StarterPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Navigate to the next page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GetStarted1()),
        );
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white, //Background color
            ),

            //Header
            Positioned(
              bottom: 710.0,
              left: 10.0,
              right: 10.0,
              child: Center(
                child: Text(Strings.welcome_to_wp,
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            //Text
            Positioned(
              bottom: 300.0,
              left: 32.0,
              right: 40.0,
              child: Center(
                child: Text(Strings.welcome_1,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),

            //Tap anywhere to begin
            Positioned(
              bottom: 50.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: Text(Strings.tap_anywhere,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    color: Color.fromARGB(255, 6, 84, 101),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}