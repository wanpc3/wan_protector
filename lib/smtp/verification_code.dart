//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

//Secure storage instance
//final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

//Generates a random number between 900000 and 100000
String generateVerificationCode() {
  final random = Random();
  int verificationCode = random.nextInt(900000) + 100000;
  return verificationCode.toString();  
}

//Function to save the code securely
Future<void> saveVerificationCode(String code) async {
  //await _secureStorage.write(key: 'verification_code', value: code);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('verification_code', code);
}

//Function to retrieve the code securely
Future<String?> getSavedVerificationCode() async {
  //return await _secureStorage.read(key: 'verification_code');
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('verification_code');
}

//Function to delete the code after use
Future<void> deleteVerificationCode() async {
  //await _secureStorage.delete(key: 'verification_code');
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('verification_code');
}