import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../strings/strings.dart';
import 'verify_code_form.dart';
import 'package:lottie/lottie.dart';

class VerifyUser extends StatelessWidget{

  final String email;

  const VerifyUser({
    super.key,
    required this.email
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: const Text(
      //     Strings.verify_title,
      //     style: TextStyle(color: Colors.black),
      //   ),
      // ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
                children: [
                  const SizedBox(height: 64),
                  const Text(
                    Strings.verify_user,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    Strings.send_verify_code,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                  //SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  SizedBox(height: 32),
                   
                  //Animation will appear here
                  Lottie.asset(
                    "assets/send_email_anim.json",
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: 32),

                  VerifyCodeForm(email: email),
                  //SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "I did not receive any email",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}