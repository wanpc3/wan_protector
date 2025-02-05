import 'package:flutter/material.dart';

final ButtonStyle registerButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color.fromARGB(255, 6, 84, 101), //Background Color
  foregroundColor: Colors.white, //Text Color
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
);

final ButtonStyle addEntryBtnStyle = ElevatedButton.styleFrom(
  backgroundColor: Color.fromARGB(255, 6, 84, 101),
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
);

final ButtonStyle saveChangesBtnStyle = ElevatedButton.styleFrom(
  backgroundColor: Color.fromARGB(255, 6, 84, 101),
  foregroundColor: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
);