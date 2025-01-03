import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../strings/strings.dart';
import 'verify_code_form.dart';

class VerifyUser extends StatelessWidget{
  const VerifyUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          Strings.verify_title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    Strings.verify_user,
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  const VerifyCodeForm(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
      ),
    );
  }
}