import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../status_bar/status_bar.dart';
import '../strings/strings.dart';
import 'get_started_1.dart';

class GetStarted2 extends StatelessWidget {
  const GetStarted2({super.key});

  @override
  Widget build(BuildContext context) {

    //Set the status bar icons to white
    setStatusBarStyle();

    return Scaffold(
      body: Stack(
        children: [
          //Background for the top half of the page
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.2,
              color: Color.fromARGB(255, 6, 84, 101),
            ),
          ),

          //Header
          Positioned(
            bottom: 380.0,
            left: 40.0,
            right: 20.0,
            child: Center(
              child: Text(Strings.get_started_2_title,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          //Text
          Positioned(
            bottom: 250.0,
            left: 35.0,
            right: 30.0,
            child: Center(
              child: Text(Strings.get_started_2,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),

          //Button: navigates to the next page
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 200.0,
                height: 60.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 98, 100, 100),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                          MaterialPageRoute(
                            builder: (context) => GetStarted1()
                          )
                      );
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20.0
                      ),
                    ),
                  ),
              ),
            ),
          ),
        ],
      )
    );
  }
}