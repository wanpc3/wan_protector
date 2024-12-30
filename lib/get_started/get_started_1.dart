import 'package:flutter/material.dart';
import '../strings/strings.dart';
import '../status_bar/status_bar.dart';
import '../custom_btn/next_btn.dart';
import 'get_started_2.dart';

class GetStarted1 extends StatelessWidget{
  GetStarted1({super.key});

  @override
  Widget build(BuildContext context) {
    //Background: Color.fromARGB(255, 6, 84, 101)

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
              child: Text(Strings.get_started_1_title,
                //textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          //Text
          Positioned(
            bottom: 275.0,
            left: 42.0,
            //right: 40.0,
            width: 320.0,
            child: Center(
              child: Text(Strings.get_started_1,
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
                    style: setNextBtnStyle(),
                    onPressed: () {
                      Navigator.push(
                      context,
                        MaterialPageRoute(
                          builder: (context) => GetStarted2()
                        )
                      );
                    },
                    child: setTextStyle_1(),
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}