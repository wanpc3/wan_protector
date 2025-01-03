import 'dart:math';

String generateVerificationCode() {
  final random = Random();
  int verificationCode = random.nextInt(900000) + 100000; //Generates a random number between 900000 and 100000
  return verificationCode.toString();  
}