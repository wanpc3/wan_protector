import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../wan_protector/wan_protector.dart';
import '../smtp/verification_code.dart';

// Firebase connection
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black),
  borderRadius: BorderRadius.all(Radius.circular(12)),
);

class VerifyCodeForm extends StatefulWidget {
  
  final String email;  // Email passed as an argument

  const VerifyCodeForm({
    super.key, required this.email
  });

  @override
  State<VerifyCodeForm> createState() => _VerifyCodeFormState();
}

class _VerifyCodeFormState extends State<VerifyCodeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _verification_code = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> verifyCode() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String? storedCode = await getSavedVerificationCode();

    if (_verification_code.text == storedCode) {
      setState(() {
        _errorMessage = null;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signing you in...')),
      );

      await deleteVerificationCode();

      // Use the email from the widget argument
      try {
        // UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        //   email: widget.email,
        //   password: 'defaultPassword'
        // );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WanProtector()),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = 'Error: ${e.message}';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid code. Please try again.';
        _isLoading = false;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _errorMessage = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            //const SizedBox(height: 16),
            TextFormField(
              controller: _verification_code,
              decoration: const InputDecoration(
                hintText: 'Enter 6-digit code',
                border: authOutlineInputBorder,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter 6-digit code';
                }
                if (value.length != 6) {
                  return 'The code must be exactly 6 digits';
                }
                return null;
              },
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 45.0,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          verifyCode();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 6, 84, 101),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Verify Code"),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
