import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../wan_protector/vault.dart';
import '../smtp/verification_code.dart';

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black),
  borderRadius: BorderRadius.all(Radius.circular(12)),
);

class VerifyCodeForm extends StatefulWidget {
  const VerifyCodeForm({super.key});

  @override
  State<VerifyCodeForm> createState() => _VerifyCodeFormState();
}

class _VerifyCodeFormState extends State<VerifyCodeForm> {
  //Get the value of that number:
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _verification_code = TextEditingController();
  String? _errorMessage;

  Future<void> verifyCode() async {
    //Retrieve the stored code
    String? storedCode = await getSavedVerificationCode();

    if (_verification_code.text == storedCode) {
      //Code matches
      setState(() {
        _errorMessage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification successful')),
      );
      
      //Delete the code after successful verification
      await deleteVerificationCode();
    
      //Navigate to the Vault screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Vault()),
      );
    } else {
      //Code does not match
      setState(() {
        _errorMessage = 'Invalid code. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
            TextFormField(
              controller: _verification_code,
              decoration: const InputDecoration(
                hintText: 'Enter 6-digit code',
                border: authOutlineInputBorder,
              ),
              keyboardType: TextInputType.number, //Specifies the number keyboard
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, //Allows digits only
              ],
              //Verification code validation
              validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter 6-digit code';
              }
              if (value.length != 6) {
                return 'The code must be exactly 6 digits';
              }
              return null;
            }
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                verifyCode();
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Color.fromARGB(255, 6, 84, 101),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}