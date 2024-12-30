import 'package:flutter/material.dart';

/* 
  This file contains all of the functions that is used in the beginning of the app UI.
*/

ButtonStyle setNextBtnStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 98, 100, 100),
    foregroundColor: Colors.yellow,
  );
}

Text setTextStyle_1() {
  return Text(
    'Next',
    style: TextStyle(
      fontSize: 20.0
    ),
  );
}

Text setTextStyle_2() {
  return Text(
    'Next',
    style: TextStyle(
      fontSize: 20.0
    ),
  );
}

Text setTextStyle_3() {
  return Text(
    'Get Started',
    style: TextStyle(
      fontSize: 20.0
    ),
  );
}